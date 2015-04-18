% Start timing
tstart = tic;

% Set up power
Pt = 10^(Pt_dBm/10); sigma2r = 10^(sigma2r_dBm/10);
Pr = 10^(Pr_dBm/10); sigma2t = 10^(sigma2t_dBm/10);
				
for ii_Nnetwork = 1:Nnetworks
	ii_Nnetwork
	
	for ii_Nshadow = 1:Nshadow
		
		for ii_Nsim = 1:Nsim

			% Temporary results storage, so the outer parfor will work with the
			% nested loops
			iter_sumrateKc_baseline_maxsinr  = zeros(Kr,length(Kc_scheds));
			iter_sumrateKc_baseline_maxrate  = zeros(Kr,length(Kc_scheds));
			iter_sumrateKc_baseline_unc      = zeros(Kr,length(Kc_scheds));
			iter_sumrateKc_baseline_tdma_inter     = zeros(Kr,length(Kc_scheds));
			iter_sumrateKc_baseline_tdma_intra     = zeros(Kr,length(Kc_scheds));
			iter_sumrateKc_maxrate           = zeros(Kr,length(Kc_scheds));
			iter_sumrateKc_maxsinr           = zeros(Kr,length(Kc_scheds));


			% Get channels
			H = networks{ii_Nnetwork}.as_matrix(ii_Nsim,ii_Nshadow);


			% Get current noise realization for the estimators
			estim_signals = raw_estim_signals;
			MS_norm_noise_realizations = raw_estim_signals.MS_norm_noise_realizations; estim_signals.MS_norm_noise_realizations = MS_norm_noise_realizations(:,:,(ii_Nnetwork-1)*Nshadow + (ii_Nshadow-1)*Nsim + ii_Nsim);
			BS_norm_noise_realizations = raw_estim_signals.BS_norm_noise_realizations; estim_signals.BS_norm_noise_realizations = BS_norm_noise_realizations(:,:,(ii_Nnetwork-1)*Nshadow + (ii_Nshadow-1)*Nsim + ii_Nsim);


			% Loop over number of users
			for ii_Kc = 1:length(Kc_scheds)

				% Schedule users based on instantaneous signal strength
				D = zeros(Kr, Kt);
					
				% Calculate metric for all eligible users
				metric = zeros(Kr, Kt);
				for l = 1:Kt
					for j = ((l-1)*Kc + 1):(l*Kc)
						metric(j,l) = norm(H(:,:,j,l),'fro')^2;
					end
				end

				% Schedule users
				for l = 1:Kt
					while sum(D(:,l)) < Kc_scheds(ii_Kc)
						[~,k] = max(metric(:,l));
						D(k,l) = 1;
						metric(k,:) = 0;
					end
				end
				

				% =-=-=-=-=-=-=-=-=-=-=
				% BASELINE PERFORMANCE
				% =-=-=-=-=-=-=-=-=-=-=

				if(sim_params.run_baselines)
					user_rates_e = PracticalTDD_func_MaxRate_perfect_CSI(H,D,Pt,sigma2r,Nd,stop_crit);
					iter_sumrateKc_baseline_maxrate(:,ii_Kc) = user_rates_e(:,end);

					user_rates_e = PracticalTDD_func_MaxSINR_perfect_CSI(H,D,Pt,sigma2r,Nd,stop_crit);
					iter_sumrateKc_baseline_maxsinr(:,ii_Kc) = user_rates_e(:,end);

					[iter_sumrateKc_baseline_tdma_inter(:,ii_Kc), iter_sumrateKc_baseline_unc(:,ii_Kc), iter_sumrateKc_baseline_tdma_intra(:,ii_Kc)] = PracticalTDD_func_singleuser_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit,estim_signals);
				end

				% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
				% Noisy MaxRate TDD Performance
				% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

				if(sim_params.run_noisy_maxrate)
					maxrate_rate_e = ...
						PracticalTDD_func_MaxRate_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
							estim_params,estim_signals,MS_robustification,BS_robustification);
					iter_sumrateKc_maxrate(:,ii_Kc) = maxrate_rate_e(:,end);
				end

				% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
				% Noisy MaxSINR TDD Performance
				% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

				if(sim_params.run_noisy_maxsinr)
					maxsinr_rate_e = ...
						PracticalTDD_func_MaxSINR_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
							estim_params,estim_signals);
					iter_sumrateKc_maxsinr(:,ii_Kc) = maxsinr_rate_e(:,end);
				end
			end
			
			% Store to permanent storage
			if(sim_params.run_baselines)
				sumrateKc_baseline_unc     (:,:,ii_Nnetwork,ii_Nshadow,ii_Nsim) = iter_sumrateKc_baseline_unc;
				sumrateKc_baseline_tdma_inter    (:,:,ii_Nnetwork,ii_Nshadow,ii_Nsim) = iter_sumrateKc_baseline_tdma_inter;
				sumrateKc_baseline_tdma_intra    (:,:,ii_Nnetwork,ii_Nshadow,ii_Nsim) = iter_sumrateKc_baseline_tdma_intra;
				sumrateKc_baseline_maxsinr (:,:,ii_Nnetwork,ii_Nshadow,ii_Nsim) = iter_sumrateKc_baseline_maxsinr;
				sumrateKc_baseline_maxrate (:,:,ii_Nnetwork,ii_Nshadow,ii_Nsim) = iter_sumrateKc_baseline_maxrate;
			end
			if(sim_params.run_noisy_maxrate)
				sumrateKc_maxrate(:,:,ii_Nnetwork,ii_Nshadow,ii_Nsim) = iter_sumrateKc_maxrate;
			end
			if(sim_params.run_noisy_maxsinr)
				sumrateKc_maxsinr (:,:,ii_Nnetwork,ii_Nshadow,ii_Nsim) = iter_sumrateKc_maxsinr;
			end
		end
	end
end


% Report timing performance
telapsed = toc(tstart);
disp(sprintf('PracticalTDD_largescale_sumrateKcsched_run: %s', seconds2human(telapsed)));


% House keeping
clear ii_Nsim iter ii_SNRd ii_Kc user_rates_e maxrate_rate_e;
