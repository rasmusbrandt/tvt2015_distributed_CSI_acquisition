function [That,Ghat] = PracticalTDD_func_BSTGEstim_MMSE_full_global_filts_wghts_robust(H,U,W,D,Pr,sigma2t,sigma2r,estim_signals,iter)
	% Parameters
	[Mr,Mt,Kr,Kt,~,~] = size(H);
	Npu_full = size(estim_signals.MS_pilots_full,2);
	
	% Estimation error variance (decreases each iteration)
	sigma2t_e = sigma2t/(iter*Npu_full*Pr/Mr + sigma2t);
	
	% Non-robust estimates that we will 'robustify'
	[That,Ghat] = PracticalTDD_func_BSTGEstim_MMSE_full_global_filters_weights(H,U,W,D,Pr,sigma2t,sigma2r,estim_signals,iter);
	
	UWUtr_sum = 0;
	for k = 1:Kr
		UWUtr_sum = UWUtr_sum + trace(U(:,:,k)*W(:,:,k)*U(:,:,k)');
	end
	
	for l = 1:Kt
		That(:,:,l) = That(:,:,l) + sigma2t_e*UWUtr_sum*eye(Mt);
		That(:,:,l) = (That(:,:,l) + That(:,:,l)')/2;
	end

end