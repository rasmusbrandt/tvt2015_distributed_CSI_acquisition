function [user_rates_e,UWsqrt_e,U_e,W_e,V_e,mu_e,nu_e,TEMP] = ...
	PracticalTDD_func_MaxRate_noisy_CSI_rho(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
	estim_params,estim_signals,MS_robustification,rho)


	% Parameters
	[Mr,Mt,Kr,Kt,~,~] = size(H);

	
	% Filter variables
	U = zeros(Mr,Nd,Kr);	  % receive filters
	W = zeros(Nd,Nd,Kr);	  % MMSE weights
	V = zeros(Mt,Nd,Kr);		% transmit filters
	for l = 1:Kt
		Dl = find(D(:,l) == 1)'; Kc = length(Dl);

		for k = Dl
			Vp = fft(eye(Mt,Nd))/sqrt(Mt);
			V(:,:,k) = sqrt(Pt/Kc)*(Vp/norm(Vp,'fro'));
		end
	end
	
	TEMP = zeros(Kr,stop_crit);
	
	
	% Performance evolution variables
	user_rates_e   = zeros(Kr,stop_crit);	% Sum rate evolution
	UWsqrt_e = zeros(Kr,stop_crit);	% ||UW^(1/2)||^2 evolution
	U_e		   = zeros(Kr,stop_crit); % ||U||^2 evolution
	W_e		   = zeros(Kr,stop_crit); % tr(W) evolution
	V_e		   = zeros(Kr,stop_crit); % ||V||^2 evolution
	mu_e		 = zeros(Kt,stop_crit); % mu evolution
	nu_e     = zeros(Kr,stop_crit); % nu evolution
	
	% Check rho
	if rho > 1
		error('Rho must be less than 1.');
	end

	
	% Iterate
	iter = 1;
	while (iter <= stop_crit)
		
		% Receiver side estimation
		[Qhat,Fhat] = estim_params.MS_channel_estimator(H,V,D,Pt,sigma2r,estim_signals,iter);
		
		% Scale down
		Qhat = rho*Qhat;
		Fhat = sqrt(rho)*Fhat;
		
		% Receive filters
		for k = 1:Kr
			if(any(D(k,:)))
				[U(:,:,k),W(:,:,k),nu_e(k,iter)] = ...
					PracticalTDD_func_MaxRate_noisy_CSI_MSOpt(Qhat(:,:,k),Fhat(:,:,k),sigma2r,Nd,MS_robustification);
			end
		end

		
		% Transmitter side estimation
		[That,Ghat] = estim_params.BS_channel_estimator(H,U,W,D,Pr,sigma2t,sigma2r,estim_signals,iter);
		What				= estim_params.BS_weight_estimator(W,Pt,sigma2r,estim_params);
		
		% Precoders
		for l = 1:Kt
			Dl = find(D(:,l) == 1)'; Kc = length(Dl);
			
			if(Kc)
				[Vs,mu_e(l,iter)] = PracticalTDD_func_MaxRate_noisy_CSI_BSOpt(That(:,:,l),Ghat,What,Dl,rho*Pt,sigma2r,Pr,sigma2t,Nd,estim_params);
				
				for n = 1:Kc
					V(:,:,Dl(n)) = Vs(:,:,Dl(n));
				end
			end
			
			% TEMP
			for k = Dl
				TEMP(k,iter) = abs(V(:,:,k)'*That(:,:,l)*V(:,:,k));
			end
		end
		
		% Scale up
		V = sqrt(1/rho)*V;

		
		% Calculate evolution measures
		user_rates_e(:,iter) = PracticalTDD_func_sdma_rate(H,V,D,sigma2r);
		
		for k = 1:Kr
			if sum(sum(W(:,:,k))) ~= 0
				UWsqrt_e(k,iter) = norm(U(:,:,k)*sqrtm(W(:,:,k)),'fro')^2;
			end
			U_e(k,iter)			 = norm(U(:,:,k),'fro')^2;
			W_e(k,iter)			 = trace(W(:,:,k));
			V_e(k,iter)		   = norm(V(:,:,k),'fro')^2;
		end

		iter = iter + 1;

	end
end