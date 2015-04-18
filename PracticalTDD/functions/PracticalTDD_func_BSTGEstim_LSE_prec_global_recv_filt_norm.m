function [That,Ghat] = PracticalTDD_func_BSTGEstim_LSE_prec_global_recv_filt_norm(H,U,W,D,Pr,sigma2t,sigma2r,estim_signals,iter)
	[Mr,Mt,Kr,Kt,~,~] = size(H);
	Nd = size(U,2);
	Npu_prec = size(estim_signals.MS_pilots_prec,2);
	
	% Helper variables
	Hb = zeros(Kt*Mt,Kr*Nd);
	active_users = find(any(D'));
	
	% Precompute square roots
	Wsqrts = zeros(size(W));
	for k = 1:Kr
		Wsqrts(:,:,k) = sqrtm(W(:,:,k));
	end
	
	% Build giant effective channel matrix
	scale_factors = ones(Kr,1); % These must be known at the designated BS (if _orthogonal_ pilots used) 
	for l = 1:Kt
		for k = active_users
			% Scale filter to maximize received SNR
			scale_factors(k) = sqrt(Pr)/norm(U(:,:,k)*Wsqrts(:,:,k),'fro');
			U_transmit = scale_factors(k)*U(:,:,k)*Wsqrts(:,:,k);
			
			Hb(((l-1)*Mt + 1):l*Mt,((k-1)*Nd + 1):k*Nd) = H(:,:,k,l)'*U_transmit;
		end
	end
	
	% Generate received signal. Transmit power set in scale factor.
	Xp = estim_signals.MS_pilots_prec; Z = sqrt(sigma2t)*estim_signals.BS_norm_noise_realizations(:,(iter-1)*Npu_prec+1:iter*Npu_prec);
	Y = Hb*Xp + Z;
	
	
	% Estimate effective channels
	Gall = zeros(Mt,Nd,Kr,Kt);
	for l = 1:Kt
		for k = active_users
			% Notice that we assume perfect global feedback of the norms of the receive filters here!
			Gall(:,:,k,l) = (1/scale_factors(k))*(Y((l-1)*Mt+1:l*Mt,:)*Xp((k-1)*Nd+1:k*Nd,:)'/(Xp((k-1)*Nd+1:k*Nd,:)*Xp((k-1)*Nd+1:k*Nd,:)'));
		end
	end
	Ghat = zeros(Mt,Nd,Kr);
	for l = 1:Kt
		Dl = find(D(:,l) == 1)';
		
		for k = Dl
			Ghat(:,:,k) = Gall(:,:,k,l);
		end
	end
	
	
	% Estimate covariance
	That = zeros(Mt,Mt,Kt);
	for l = 1:Kt
		for k = 1:Kr
			That(:,:,l) = That(:,:,l) + Gall(:,:,k,l)*Gall(:,:,k,l)';
		end
		That(:,:,l) = (That(:,:,l) + That(:,:,l)')/2;
	end
end