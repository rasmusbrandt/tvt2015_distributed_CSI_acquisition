function [user_rates_e,UWsqrt_e,U_e,W_e,V_e,mu_e,nu_e,TEMP] = ...
	PracticalTDD_func_MaxRate_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
	estim_params,estim_signals,MS_robustification,BS_robustification)

	if(BS_robustification)
		rho = min((Pr/sigma2t)/(Pt/sigma2r),1);
	else
		rho = 1;
	end
	
	[user_rates_e,UWsqrt_e,U_e,W_e,V_e,mu_e,nu_e,TEMP] = ...
	PracticalTDD_func_MaxRate_noisy_CSI_rho(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
	estim_params,estim_signals,MS_robustification,rho);
end