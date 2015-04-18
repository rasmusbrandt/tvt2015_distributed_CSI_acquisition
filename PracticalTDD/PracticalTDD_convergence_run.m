% Start timing
tstart = tic;

% Consistency check
if(any(sum((D == 1),2) > 1))
	error('Inconsistency in D. We do not allow for joint processing.');
end
	
% Local shortcuts
sigma2r = 1; Pt = sigma2r*(10^(SNRd_dB/10));
sigma2t = 1; Pr = sigma2t*(10^(SNRu_dB/10));


parfor ii_Nsim = 1:Nsim
	ii_Nsim
	
	
	% Get channels
	H = network.as_matrix(ii_Nsim);

	
	% Get current noise realization for the estimators
	estim_signals = raw_estim_signals;
	MS_norm_noise_realizations = raw_estim_signals.MS_norm_noise_realizations; estim_signals.MS_norm_noise_realizations = MS_norm_noise_realizations(:,:,ii_Nsim);
	BS_norm_noise_realizations = raw_estim_signals.BS_norm_noise_realizations; estim_signals.BS_norm_noise_realizations = BS_norm_noise_realizations(:,:,ii_Nsim);
	
	
	% =-=-=-=-=-=-=-=-=-=-=
	% BASELINE PERFORMANCE
	% =-=-=-=-=-=-=-=-=-=-=

	if(sim_params.run_baselines)
		[convergence_baseline_tdma(:,ii_Nsim), convergence_baseline_unc(:,ii_Nsim)] = PracticalTDD_func_singleuser_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit_noisy,estim_signals);
	end
	
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	% Perfect MaxRate TDD Performance
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	if(sim_params.run_perfect_maxrate)
		[convergence_maxrate_rates_perfect(:,:,ii_Nsim), convergence_maxrate_UWsqrt_perfect(:,:,ii_Nsim), convergence_maxrate_U_perfect(:,:,ii_Nsim),     ...
		 convergence_maxrate_W_perfect(:,:,ii_Nsim), convergence_maxrate_V_perfect(:,:,ii_Nsim), ...
		 convergence_maxrate_mu_perfect(:,:,ii_Nsim),TEMP_PERFECT] = ...
			PracticalTDD_func_MaxRate_perfect_CSI(H,D,Pt,sigma2r,Nd,stop_crit_perfect);
	end

	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	% Noisy MaxRate TDD Performance
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

	if(sim_params.run_noisy_maxrate)
		[convergence_maxrate_rates_noisy(:,:,ii_Nsim), convergence_maxrate_UWsqrt_noisy(:,:,ii_Nsim), convergence_maxrate_U_noisy(:,:,ii_Nsim),     ...
		 convergence_maxrate_W_noisy(:,:,ii_Nsim), convergence_maxrate_V_noisy(:,:,ii_Nsim), ...
		 convergence_maxrate_mu_noisy(:,:,ii_Nsim), convergence_maxrate_nu_noisy(:,:,ii_Nsim),TEMP_NOISY] = ...
			PracticalTDD_func_MaxRate_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit_noisy, ...
				estim_params,estim_signals,MS_robustification,BS_robustification);
	end
		
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	% Perfect MaxSINR TDD Performance
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

	if(sim_params.run_perfect_maxsinr)
		convergence_maxsinr_rates_perfect(:,:,ii_Nsim) = ...
			PracticalTDD_func_MaxSINR_perfect_CSI(H,Dsched,Pt,sigma2r,Nd,stop_crit_perfect);
	end

	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	% Noisy MaxSINR TDD Performance
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

	if(sim_params.run_noisy_maxsinr)
		convergence_maxsinr_rates_noisy(:,:,ii_Nsim) = ...
			PracticalTDD_func_MaxSINR_noisy_CSI(H,Dsched,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit_noisy, ...
				estim_params,estim_signals);
	end
end


% Report timing performance
telapsed = toc(tstart);
disp(sprintf('PracticalTDD_convergence_run: %s', seconds2human(telapsed)));


% House keeping
clear ii_Nsim iter C;