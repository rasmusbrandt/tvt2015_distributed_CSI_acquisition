% Start timing
tstart = tic;

% Consistency check
if(any(sum((D == 1),2) > 1))
	error('Inconsistency in D. We do not allow for joint processing.');
end


parfor ii_Nsim = 1:Nsim
	ii_Nsim
	
	% Temporary results storage, so the outer parfor will work with the
	% nested loops
	iter_sumrateSIR_baseline_maxsinr    = zeros(Kr,length(SIR_dBs));
	iter_sumrateSIR_baseline_maxrate    = zeros(Kr,length(SIR_dBs));
	iter_sumrateSIR_baseline_unc        = zeros(Kr,length(SIR_dBs));
	iter_sumrateSIR_baseline_tdma       = zeros(Kr,length(SIR_dBs));
	iter_sumrateSIR_baseline_tdma_intra = zeros(Kr,length(SIR_dBs));
	iter_sumrateSIR_maxrate             = zeros(Kr,length(SIR_dBs));
	iter_sumrateSIR_maxsinr             = zeros(Kr,length(SIR_dBs));


	% Get raw channels (with SIR = 0 dB)
	H_raw = network.as_matrix(ii_Nsim);
	H = H_raw;

	% Get current noise realization for the estimators
	estim_signals = raw_estim_signals;
	MS_norm_noise_realizations = raw_estim_signals.MS_norm_noise_realizations; estim_signals.MS_norm_noise_realizations = MS_norm_noise_realizations(:,:,ii_Nsim);
	BS_norm_noise_realizations = raw_estim_signals.BS_norm_noise_realizations; estim_signals.BS_norm_noise_realizations = BS_norm_noise_realizations(:,:,ii_Nsim);
	
	% Set up powers
	sigma2r = 1; Pt = sigma2r*(10^(SNRd_dB/10));
	sigma2t = 1; Pr = sigma2t*(10^(SNRu_dB/10));

	% Loop over downlink SIRs
	for ii_SIR = 1:length(SIR_dBs)

		% Get scaled channels
		alph = 10^(SIR_dBs(ii_SIR)/10);
		for l = 1:Kt
			% Loop over all users not served
			for k = find(~D(:,l))
				H(:,:,k,l) = 1/sqrt(alph)*H_raw(:,:,k,l);
			end
		end

		% =-=-=-=-=-=-=-=-=-=-=
		% BASELINE PERFORMANCE
		% =-=-=-=-=-=-=-=-=-=-=

		if(sim_params.run_baselines)
			user_rates_e = PracticalTDD_func_MaxRate_perfect_CSI(H,D,Pt,sigma2r,Nd,stop_crit);
			iter_sumrateSIR_baseline_maxrate(:,ii_SIR) = user_rates_e(:,end);

			user_rates_e = PracticalTDD_func_MaxSINR_perfect_CSI(H,Dsched,Pt,sigma2r,Nd,stop_crit);
			iter_sumrateSIR_baseline_maxsinr(:,ii_SIR) = user_rates_e(:,end);

			[iter_sumrateSIR_baseline_tdma(:,ii_SIR), iter_sumrateSIR_baseline_unc(:,ii_SIR), iter_sumrateSIR_baseline_tdma_intra(:,ii_SIR)] = PracticalTDD_func_singleuser_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit,estim_signals);
		end


		% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		% Noisy MaxRate TDD Performance
		% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

		if(sim_params.run_noisy_maxrate)
			maxrate_rate_e = ...
				PracticalTDD_func_MaxRate_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
					estim_params,estim_signals,MS_robustification,BS_robustification);
			iter_sumrateSIR_maxrate(:,ii_SIR) = maxrate_rate_e(:,end);
		end

		% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		% Noisy MaxSINR TDD Performance
		% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		if(sim_params.run_noisy_maxsinr)
			maxsinr_rate_e = ...
				PracticalTDD_func_MaxSINR_noisy_CSI(H,Dsched,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
					estim_params,estim_signals);
			iter_sumrateSIR_maxsinr(:,ii_SIR) = maxsinr_rate_e(:,end);
		end
		
	end

	
	% Store to permanent storage
	if(sim_params.run_baselines)
		sumrateSIR_baseline_unc       (:,:,ii_Nsim) = iter_sumrateSIR_baseline_unc;
		sumrateSIR_baseline_tdma      (:,:,ii_Nsim) = iter_sumrateSIR_baseline_tdma;
		sumrateSIR_baseline_tdma_intra(:,:,ii_Nsim) = iter_sumrateSIR_baseline_tdma_intra;
		sumrateSIR_baseline_maxsinr   (:,:,ii_Nsim) = iter_sumrateSIR_baseline_maxsinr;
		sumrateSIR_baseline_maxrate   (:,:,ii_Nsim) = iter_sumrateSIR_baseline_maxrate;
	end
	if(sim_params.run_noisy_maxrate)
		sumrateSIR_maxrate(:,:,ii_Nsim) = iter_sumrateSIR_maxrate;
	end
	if(sim_params.run_noisy_maxsinr)
		sumrateSIR_maxsinr(:,:,ii_Nsim)  = iter_sumrateSIR_maxsinr;
	end
end


% Report timing performance
telapsed = toc(tstart);
disp(sprintf('PracticalTDD_sumrateSIR_run: %s', seconds2human(telapsed)));


% House keeping
clear ii_Nsim iter ii_SIR user_rates_e maxrate_rate_e;