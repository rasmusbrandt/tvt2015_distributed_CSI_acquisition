function [Qhat,Fhat] = PracticalTDD_func_MSQFEstim_MMSE_full_global_filters(H,V,D,Pt,sigma2r,estim_signals,iter)
	[Mr,Mt,Kr,Kt,~,~] = size(H); Kc = Kr/Kt;
	Nd = size(V,2);
	Npd_full = size(estim_signals.BS_pilots_full,2);

	% Helper variables
	Hb = zeros(Kr*Mr,Kt*Mt);

	% Build giant channel matrix
	for k = 1:Kr
		for l = 1:Kt
			Hb((k-1)*Mr+1:k*Mr,(l-1)*Mt+1:l*Mt) = H(:,:,k,l);
		end
	end
	
	% Generate received signal. Note that we assume that the estimates are 
	% continuously improved, for every iteration. This could be done in a more
	% computationally advantageous way, but for simplicity we just redo 
	% the estimation here.
	Xp = sqrt(Pt/(Mt*Kc))*repmat(estim_signals.BS_pilots_full,1,iter); Z = sqrt(sigma2r)*estim_signals.MS_norm_noise_realizations(:,1:iter*Npd_full);
	Y = Hb*Xp + Z;
	
	% Estimate channels
	Hestim = zeros(Mr,Mt,Kr,Kt);
	for k = 1:Kr
		for l = 1:Kt
			Hestim(:,:,k,l) = 1/(iter*Npd_full*Pt/(Mt*Kc) + sigma2r)*Y((k-1)*Mr+1:k*Mr,:)*Xp((l-1)*Mt+1:l*Mt,:)';
		end
	end
	
	% Get effective channels (assume feedback of V here) and covariance.
	Qhat = zeros(Mr,Mr,Kr); Fhat = zeros(Mr,Nd,Kr);
	for k = 1:Kr
		Qhat(:,:,k) = sigma2r*eye(Mr);
		
		for l = 1:Kt
			Dl = find(D(:,l) == 1)';
			
			for j = Dl
				Qhat(:,:,k) = Qhat(:,:,k) + Hestim(:,:,k,l)*(V(:,:,j)*V(:,:,j)')*Hestim(:,:,k,l)';
			end
			
			if(D(k,l) == 1)
				Fhat(:,:,k) = Hestim(:,:,k,l)*V(:,:,k);
			end
		end
		Qhat(:,:,k) = (Qhat(:,:,k) + Qhat(:,:,k)')/2;
	end
	
end