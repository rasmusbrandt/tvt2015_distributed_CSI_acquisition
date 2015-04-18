function [That,Ghat] = PracticalTDD_func_BSTGEstim_MMSE_full_global_filters_weights(H,U,W,D,Pr,sigma2t,~,estim_signals,iter)
	% Parameters
	[Mr,Mt,Kr,Kt,~,~] = size(H);
	Nd = size(U,2);
	Npu_full = size(estim_signals.MS_pilots_full,2);
	
	% Helper variables
	Hb = zeros(Kt*Mt,Kr*Mr);

	% Build giant channel matrix
	for l = 1:Kt
		for k = 1:Kr
			Hb((l-1)*Mt+1:l*Mt,(k-1)*Mr+1:k*Mr) = H(:,:,k,l)';
		end
	end
	
	% Generate received signal. Note that we assume that the estimates are 
	% continuously improved, for every iteration. This could be done in a more
	% computationally advantageous way, but for simplicity we just redo 
	% the estimation here.
	Xp = sqrt(Pr/Mr)*repmat(estim_signals.MS_pilots_full,1,iter); Z = sqrt(sigma2t)*estim_signals.BS_norm_noise_realizations(:,1:iter*Npu_full);
	Y = Hb*Xp + Z;
	
	
	% Estimate channels
	Hestim_reci = zeros(Mt,Mr,Kr,Kt);
	for l = 1:Kt
		for k = 1:Kr
			Hestim_reci(:,:,k,l) = 1/(iter*Npu_full*Pr/Mr + sigma2t)*Y((l-1)*Mt+1:l*Mt,:)*Xp((k-1)*Mr+1:k*Mr,:)';
		end
	end
	
	% Get effective channels (assume feedback of U and W) and covariance
	Ghat = zeros(Mt,Nd,Kr); That = zeros(Mt,Mt,Kt);
	for l = 1:Kt
		for k = 1:Kr
			That(:,:,l) = That(:,:,l) + Hestim_reci(:,:,k,l)*(U(:,:,k)*W(:,:,k)*U(:,:,k)')*Hestim_reci(:,:,k,l)';
			
			if(D(k,l) == 1)
				Ghat(:,:,k) = Hestim_reci(:,:,k,l)*U(:,:,k)*sqrtm(W(:,:,k));
			end
		end
		That(:,:,l) = (That(:,:,l) + That(:,:,l)')/2;
	end

end