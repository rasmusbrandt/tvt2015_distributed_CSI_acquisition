function [That,Ghat] = PracticalTDD_func_BSTGEstim_LSE_prec(H,U,W,D,Pr,sigma2t,sigma2r,estim_signals,iter)
	% Parameters
	[~,Mt,Kr,Kt,~,~] = size(H);
	Nd = size(U,2);
	Npu_prec = size(estim_signals.MS_pilots_prec,2);
	
	% Helper variables
	Hb = zeros(Kt*Mt,Kr*Nd);
	active_users = find(any(D'));
	
	% Precompute square roots
	Wsqrts = zeros(size(W));
	for k = 1:Kr
		if sum(sum(W(:,:,k))) ~= 0
			Wsqrts(:,:,k) = sqrtm(W(:,:,k));
		end
	end
	
	% Build giant effective channel matrix
	scale_factor = sqrt(Pr*sigma2r/Nd); % Must be known at the designated BS
	for l = 1:Kt
		for k = active_users
			% Get proposed filters from resource allocation
			UWsqrt_prop = U(:,:,k)*Wsqrts(:,:,k);
			UWsqrt_prop_Fnormsq = norm(UWsqrt_prop,'fro')^2;

			% Perform clipping if needed
			if(UWsqrt_prop_Fnormsq <= Nd/sigma2r)
				% Not needed if perfect CSI or MS_robustification activated
				UWsqrt_normalized = UWsqrt_prop;
			else
				% Can be needed for imperfect CSI
				UWsqrt_normalized = sqrt(Nd/sigma2r)*UWsqrt_prop/sqrt(UWsqrt_prop_Fnormsq);
			end
			
			% Scale it to maximize received SNR
			UWsqrt_transmit = scale_factor*UWsqrt_normalized;
			
			Hb(((l-1)*Mt + 1):l*Mt,((k-1)*Nd + 1):k*Nd) = H(:,:,k,l)'*UWsqrt_transmit;
		end
	end
	
	% Generate received signal. Transmit power set in scale factor.
	Xp = estim_signals.MS_pilots_prec; Z = sqrt(sigma2t)*estim_signals.BS_norm_noise_realizations(:,(iter-1)*Npu_prec+1:iter*Npu_prec);
	Y = Hb*Xp + Z;
	
	
	% Estimate effective channels
	Ghat = zeros(Mt,Nd,Kr);
	for l = 1:Kt
		Dl = find(D(:,l) == 1)';

		for k = Dl
			Ghat(:,:,k) = (1/scale_factor)*(Y((l-1)*Mt+1:l*Mt,:)*Xp((k-1)*Nd+1:k*Nd,:)'/(Xp((k-1)*Nd+1:k*Nd,:)*Xp((k-1)*Nd+1:k*Nd,:)'));
		end
	end
	
	
	% Estimate covariance
	Sxc = (1/scale_factor^2)*(1/Npu_prec)*(Y*Y');
	That = zeros(Mt,Mt,Kt);
	for l = 1:Kt
		That(:,:,l) = Sxc((l-1)*Mt+1:l*Mt,(l-1)*Mt+1:l*Mt);
		That(:,:,l) = (That(:,:,l) + That(:,:,l)')/2;
	end
end