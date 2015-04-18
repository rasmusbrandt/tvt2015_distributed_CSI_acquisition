% Start timing
tstart = tic;

% Consistency check
if(any(sum((D == 1),2) > 1))
	error('Inconsistency in D. We do not allow for joint processing.');
end

% Set up powers
sigma2r = 1; Pt = sigma2r*(10^(SNRd_dB/10));
sigma2t = 1; Pr = sigma2t*(10^(SNRu_dB/10));

disp('Calculating performance as a function of pilot length');
parfor ii_Nsim = 1:Nsim
	ii_Nsim

	% Temporary estim_params, to make parfor happy
	iter_estim_params = estim_params;
	
	% Temporary results storage, so the outer parfor will work with the
	% nested loops
	iter_pilotComplexity_prec_maxrate = zeros(Kr,length(Nps));
  iter_pilotComplexity_precGLOB_maxrate = zeros(Kr,length(Nps));
	iter_pilotComplexity_full_maxrate = zeros(Kr,length(Nps));

	% Get channels
	H = network.as_matrix(ii_Nsim);

	
	for ii_Np = 1:length(Nps)
		% Generate pilots of correct length
		iter_estim_params.Npd_prec = Nps(ii_Np); iter_estim_params.Npu_prec = Nps(ii_Np);
		iter_estim_params.Npd_full = Nps(ii_Np); iter_estim_params.Npu_full = Nps(ii_Np);
		estim_signals = PracticalTDD_func_generate_raw_estim_signals(Mr,Mt,Kr,Kt,Nd,stop_crit,Nsim,iter_estim_params);
		
		% Get current noise realization for the estimators, with correct length
		estim_signals.MS_norm_noise_realizations = MS_norm_noise_realizations(:,1:Nps(ii_Np)*stop_crit,ii_Nsim);
		estim_signals.BS_norm_noise_realizations = BS_norm_noise_realizations(:,1:Nps(ii_Np)*stop_crit,ii_Nsim);
		
		% Run the algorithm
		MS_robustification = 1; BS_robustification = 1;
		iter_estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
		iter_estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec;
		maxrate_rate_e = ...
			PracticalTDD_func_MaxRate_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
				iter_estim_params,estim_signals,MS_robustification,BS_robustification);
		iter_pilotComplexity_prec_maxrate(:,ii_Np) = maxrate_rate_e(:,end);
		
		
		MS_robustification = 1; BS_robustification = 1;
		iter_estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
		iter_estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec_global_recv_filt_norm;
		maxrate_rate_e = ...
			PracticalTDD_func_MaxRate_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
				iter_estim_params,estim_signals,MS_robustification,BS_robustification);
		iter_pilotComplexity_precGLOB_maxrate(:,ii_Np) = maxrate_rate_e(:,end);
		
		
		MS_robustification = 1; BS_robustification = 0;
		iter_estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_MMSE_full_global_filters;
		iter_estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_MMSE_full_global_filters_weights;
		maxrate_rate_e = ...
			PracticalTDD_func_MaxRate_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
				iter_estim_params,estim_signals,MS_robustification,BS_robustification);
		iter_pilotComplexity_full_maxrate(:,ii_Np) = maxrate_rate_e(:,end);
		
	end
	
	% Store results
	pilotComplexity_prec_maxrate(:,:,ii_Nsim) = iter_pilotComplexity_prec_maxrate;
	pilotComplexity_precGLOB_maxrate(:,:,ii_Nsim) = iter_pilotComplexity_precGLOB_maxrate;
	pilotComplexity_full_maxrate(:,:,ii_Nsim) = iter_pilotComplexity_full_maxrate;
end

disp('Calculating flops as a function of pilot length');
for ii_Np = 1:length(Nps)
	pilotComplexity_RBWMMSE_flops(ii_Np) = ...
		(2/3)*Mr^3 + 4*Nd*Mr^2 + Mr^2*Nd + Mr^2 + 2*Mr + Nd^2*Mr + Nd + (1/3)*Nd^3 + Mr*Nd^2 + ...
			(1/3)*Mt^3/Kc + 2*Nd*Mt^2 + Mt*Nd^2;

	pilotComplexity_prec_flops(ii_Np) = ...
			Mr*Nps(ii_Np)*Nd + Mr^2*Nps(ii_Np) + ...
				Mt*Nps(ii_Np)*Nd + Mt^2*Nps(ii_Np)/Kc;
		
	pilotComplexity_precGLOB_flops(ii_Np) = ...
			Mr*Nps(ii_Np)*Nd + Mr^2*Nps(ii_Np) + ...
				(Mt*Nps(ii_Np)*Nd + Mt^2*Nd + Mt^2)*Kr/Kc;
	
	pilotComplexity_full_flops(ii_Np) = ...
			Mr*Nps(ii_Np)*Mt*Kt + (Mr*Mt*Nd + Mr^2*Nd + Mr^2)*Kr + Mr + ...
				(Mt*Nps(ii_Np)*Mr + Mt*Mr*Nd + Mt^2*Nd + Mt^2)*Kr/Kc;
end


% Report timing performance
telapsed = toc(tstart);
disp(sprintf('PracticalTDD_pilotComplexity_run: %s', seconds2human(telapsed)));


% House keeping
clear ii_Nsim iter ii_SNRd ii_SNRu user_rates_e maxrate_rate_e;