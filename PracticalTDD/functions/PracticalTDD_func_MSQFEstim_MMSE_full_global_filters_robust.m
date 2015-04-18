function [Qhat,Fhat] = PracticalTDD_func_MSQFEstim_MMSE_full_global_filters_robust(H,V,D,Pt,sigma2r,estim_signals,iter)
	[Mr,Mt,Kr,Kt,~,~] = size(H); Kc = Kr/Kt;
	Npd_full = size(estim_signals.BS_pilots_full,2);
	
	% Estimation error variance (decreases each iteration)
	sigma2r_e = sigma2r/(iter*Npd_full*Pt/(Mt*Kc) + sigma2r);
	
	% Non-robust estimates that we will 'robustify'
	[Qhat,Fhat] = PracticalTDD_func_MSQFEstim_MMSE_full_global_filters(H,V,D,Pt,sigma2r,estim_signals,iter);

	Vnorms_sum = 0;
	for k = 1:Kr
		Vnorms_sum = Vnorms_sum + norm(V(:,:,k),'fro')^2;
	end
	
	for k = 1:Kr
		Qhat(:,:,k) = Qhat(:,:,k) + sigma2r_e*Vnorms_sum*eye(Mr);
		Qhat(:,:,k) = (Qhat(:,:,k) + Qhat(:,:,k)')/2;
	end

end