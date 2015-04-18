function [Qhat,Fhat] = PracticalTDD_func_MSQFEstim_LSE_prec(H,V,D,Pt,sigma2r,estim_signals,iter)
	[Mr,~,Kr,Kt,~,~] = size(H);
	Nd = size(V,2);
	Npd_prec = size(estim_signals.BS_pilots_prec,2);

	% Build giant effective channel matrix
	Hb = zeros(Kr*Mr,Kr*Nd);
	for k = 1:Kr
		for j = 1:Kr
			dinvj = find(D(j,:) == 1);
			
			if dinvj
				Hb(((k-1)*Mr + 1):k*Mr,((j-1)*Nd+1):j*Nd) = H(:,:,k,dinvj)*V(:,:,j);
			end
		end
	end
	
	% Generate received signal. Transmit power is in the precoders V.
	Xp = estim_signals.BS_pilots_prec; Z = sqrt(sigma2r)*estim_signals.MS_norm_noise_realizations(:,(iter-1)*Npd_prec+1:iter*Npd_prec);
	Y = Hb*Xp + Z;
	
	% Estimate covariance
	Qxc = (1/Npd_prec)*(Y*Y'); Qhat = zeros(Mr,Mr,Kr);
	for k = 1:Kr
		Qhat(:,:,k) = Qxc((k-1)*Mr+1:k*Mr,(k-1)*Mr+1:k*Mr);
		Qhat(:,:,k) = (Qhat(:,:,k) + Qhat(:,:,k)')/2;
	end
	
	% Estimate effective channels
	Fhat = zeros(Mr,Nd,Kr);
	for k = 1:Kr
		Fhat(:,:,k) = Y((k-1)*Mr+1:k*Mr,:)*Xp((k-1)*Nd+1:k*Nd,:)'/(Xp((k-1)*Nd+1:k*Nd,:)*Xp((k-1)*Nd+1:k*Nd,:)');
	end
end