% Set up pilots, noise realizations and results storage
PracticalTDD_convergence_setup;


% FULL

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_MMSE_full_global_filters;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_MMSE_full_global_filters_weights;


% (MSr = 0, BSr = 0) and baselines
MS_robustification = 0; BS_robustification = 0;

sim_params.run_baselines			 = true;
sim_params.run_perfect_maxrate = true;
sim_params.run_perfect_maxsinr = true;
sim_params.run_noisy_maxrate   = false;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_convergence_run;
convergence_perfect_maxrate				= convergence_maxrate_rates_perfect; clear convergence_maxrate_rates_perfect;
convergence_perfect_maxsinr				= convergence_maxsinr_rates_perfect; clear convergence_maxsinr_rates_perfect;
convergence_full_baseline_unc     = convergence_baseline_unc; clear convergence_baseline_unc;
convergence_full_baseline_tdma    = convergence_baseline_tdma; clear convergence_baseline_tdma;



% PREC

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec;


% (MSr = 0, BSr = 0) and baselines
MS_robustification = 0; BS_robustification = 0;

sim_params.run_baselines			 = false;
sim_params.run_perfect_maxrate = false;
sim_params.run_perfect_maxsinr = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_convergence_run;
convergence_prec_MSr0BSr0_maxrate = convergence_maxrate_rates_noisy; clear convergence_maxrate_rates_noisy;

% (MSr = 1, BSr = 1)
MS_robustification = 1; BS_robustification = 1;

sim_params.run_baselines			 = false;
sim_params.run_perfect_maxrate = false;
sim_params.run_perfect_maxsinr = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_convergence_run;
convergence_prec_MSr1BSr1_maxrate = convergence_maxrate_rates_noisy; clear convergence_maxrate_rates_noisy;


% PREC GLOBAL

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec_global_recv_filt_norm;


% (MSr = 1, BSr = 0)
MS_robustification = 1; BS_robustification = 0;

sim_params.run_baselines			 = false;
sim_params.run_perfect_maxrate = false;
sim_params.run_perfect_maxsinr = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_convergence_run;
convergence_precGLOB_MSr1BSr0_maxrate = convergence_maxrate_rates_noisy; clear convergence_maxrate_rates_noisy;
