% Start timing
tstart = tic;
	
% Convert powers into linear scale
Pt = 10^(Pt_dBm/10); sigma2r = 10^(sigma2r_dBm/10);
Pr = 10^(Pr_dBm/10); sigma2t = 10^(sigma2t_dBm/10);

for ii_Nsim = 1:Nsim
	ii_Nsim
	
	
	% Get channels
	H = network.as_matrix(ii_Nsim);
	
	% MaxRate scheduling
	Dmaxrate = zeros(Kr,Kt);
	metric = zeros(Kr,Kt);
	for l = 1:Kt
		for j = ((l-1)*Kc + 1):((l-1)*Kc + Kc)
			metric(j,l) = norm(H(:,:,j,l),'fro')^2;
		end
	end

	% Schedule users that are left
	for l = 1:Kt
		while sum(Dmaxrate(:,l)) < maxrate_max_scheduled_users
			[~,k] = max(metric(:,l));
			Dmaxrate(k,l) = 1;
			metric(k,:) = 0;
		end
	end

	% MaxSINR scheduling
	Dmaxsinr = zeros(Kr,Kt);
	metric = zeros(Kr,Kt);
	for l = 1:Kt
		for j = ((l-1)*Kc + 1):((l-1)*Kc + Kc)
			metric(j,l) = norm(H(:,:,j,l),'fro')^2;
		end
	end

	% Schedule users that are left
	for l = 1:Kt
		while sum(Dmaxsinr(:,l)) < maxsinr_max_scheduled_users
			[~,k] = max(metric(:,l));
			Dmaxsinr(k,l) = 1;
			metric(k,:) = 0;
		end
	end

	% TDMA/unc scheduling
	Dtdmaunc = zeros(Kr,Kt);

	% Calculate metric for all eligible users
	metric = zeros(Kr,Kt);
	for l = 1:Kt
		for j = ((l-1)*Kc + 1):((l-1)*Kc + Kc)
			metric(j,l) = norm(H(:,:,j,l),'fro')^2;
		end
	end

	% Schedule users that are left
	for l = 1:Kt
		while sum(Dtdmaunc(:,l)) < 1 % Only schedule best UE here!
			[~,k] = max(metric(:,l));
			Dtdmaunc(k,l) = 1;
			metric(k,:) = 0;
		end
	end

	
	% Get current noise realization for the estimators
	estim_signals = raw_estim_signals;
	MS_norm_noise_realizations = raw_estim_signals.MS_norm_noise_realizations; estim_signals.MS_norm_noise_realizations = MS_norm_noise_realizations(:,:,ii_Nsim);
	BS_norm_noise_realizations = raw_estim_signals.BS_norm_noise_realizations; estim_signals.BS_norm_noise_realizations = BS_norm_noise_realizations(:,:,ii_Nsim);
	
	
	% =-=-=-=-=-=-=-=-=-=-=
	% BASELINE PERFORMANCE
	% =-=-=-=-=-=-=-=-=-=-=

	if(sim_params.run_baselines)
		[convergence_baseline_tdma(:,ii_Nsim), convergence_baseline_unc(:,ii_Nsim)] = PracticalTDD_func_singleuser_noisy_CSI(H,Dtdmaunc,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit_noisy,estim_signals);
	end
	
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	% Perfect MaxRate TDD Performance
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	if(sim_params.run_perfect_maxrate)
		[convergence_maxrate_rates_perfect(:,:,ii_Nsim), convergence_maxrate_UWsqrt_perfect(:,:,ii_Nsim), convergence_maxrate_U_perfect(:,:,ii_Nsim),     ...
		 convergence_maxrate_W_perfect(:,:,ii_Nsim), convergence_maxrate_V_perfect(:,:,ii_Nsim), ...
		 convergence_maxrate_mu_perfect(:,:,ii_Nsim),TEMP_PERFECT] = ...
			PracticalTDD_func_MaxRate_perfect_CSI(H,Dmaxrate,Pt,sigma2r,Nd,stop_crit_perfect);
	end

	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	% Noisy MaxRate TDD Performance
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

	if(sim_params.run_noisy_maxrate)
		[convergence_maxrate_rates_noisy(:,:,ii_Nsim), convergence_maxrate_UWsqrt_noisy(:,:,ii_Nsim), convergence_maxrate_U_noisy(:,:,ii_Nsim),     ...
		 convergence_maxrate_W_noisy(:,:,ii_Nsim), convergence_maxrate_V_noisy(:,:,ii_Nsim), ...
		 convergence_maxrate_mu_noisy(:,:,ii_Nsim), convergence_maxrate_nu_noisy(:,:,ii_Nsim),TEMP_NOISY] = ...
			PracticalTDD_func_MaxRate_noisy_CSI(H,Dmaxrate,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit_noisy, ...
				estim_params,estim_signals,MS_robustification,BS_robustification);
	end
		
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	% Perfect MaxSINR TDD Performance
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

	if(sim_params.run_perfect_maxsinr)
		convergence_maxsinr_rates_perfect(:,:,ii_Nsim) = ...
			PracticalTDD_func_MaxSINR_perfect_CSI(H,Dmaxsinr,Pt,sigma2r,Nd,stop_crit_perfect);
	end

	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	% Noisy MaxSINR TDD Performance
	% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

	if(sim_params.run_noisy_maxsinr)
		convergence_maxsinr_rates_noisy(:,:,ii_Nsim) = ...
			PracticalTDD_func_MaxSINR_noisy_CSI(H,Dmaxsinr,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit_noisy, ...
				estim_params,estim_signals);
	end
end


% Report timing performance
telapsed = toc(tstart);
disp(sprintf('PracticalTDD_convergence_run: %s', seconds2human(telapsed)));


% House keeping
clear ii_Nsim iter C;
