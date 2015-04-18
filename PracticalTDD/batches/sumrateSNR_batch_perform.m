% Set up pilots, noise realizations and results storage
PracticalTDD_sumrateSNR_setup;


% FULL

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_MMSE_full_global_filters;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_MMSE_full_global_filters_weights;


% (MSr = 0, BSr = 0) and baselines
MS_robustification = 0; BS_robustification = 0;

sim_params.run_baselines			 = true;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = true;
PracticalTDD_sumrateSNR_run;
sumrateSNR_perfect_maxrate = sumrateSNR_baseline_maxrate; clear sumrateSNR_baseline_maxrate;
sumrateSNR_perfect_maxsinr = sumrateSNR_baseline_maxsinr; clear sumrateSNR_baseline_maxsinr;
sumrateSNR_full_baseline_tdma = sumrateSNR_baseline_tdma; clear sumrateSNR_baseline_tdma;
sumrateSNR_full_baseline_unc  = sumrateSNR_baseline_unc;  clear sumrateSNR_baseline_unc;
sumrateSNR_full_maxsinr = sumrateSNR_maxsinr; clear sumrateSNR_maxsinr;
sumrateSNR_full_MSr0BSr0_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;

% (MSr = 1, BSr = 0)
MS_robustification = 1; BS_robustification = 0;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_full_MSr1BSr0_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;

% (MSr = 0, BSr = 1)
MS_robustification = 0; BS_robustification = 1;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_full_MSr0BSr1_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;

% (MSr = 1, BSr = 1)
MS_robustification = 1; BS_robustification = 1;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_full_MSr1BSr1_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;


% Traditional robust
estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_MMSE_full_global_filters_robust;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_MMSE_full_global_filts_wghts_robust;

MS_robustification = 0; BS_robustification = 0;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_full_tradrobust_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;



% PREC

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec;


% (MSr = 0, BSr = 0) and baselines
MS_robustification = 0; BS_robustification = 0;

sim_params.run_baselines			 = true;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = true;
PracticalTDD_sumrateSNR_run;
sumrateSNR_prec_baseline_tdma = sumrateSNR_baseline_tdma; clear sumrateSNR_baseline_tdma;
sumrateSNR_prec_baseline_unc  = sumrateSNR_baseline_unc;  clear sumrateSNR_baseline_unc;
sumrateSNR_prec_maxsinr = sumrateSNR_maxsinr; clear sumrateSNR_maxsinr;
sumrateSNR_prec_MSr0BSr0_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;

% (MSr = 1, BSr = 0)
MS_robustification = 1; BS_robustification = 0;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_prec_MSr1BSr0_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;

% (MSr = 0, BSr = 1)
MS_robustification = 0; BS_robustification = 1;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_prec_MSr0BSr1_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;

% (MSr = 1, BSr = 1)
MS_robustification = 1; BS_robustification = 1;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_prec_MSr1BSr1_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;


% PREC GLOBAL

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec_global_recv_filt_norm;


% (MSr = 0, BSr = 0)
MS_robustification = 0; BS_robustification = 0;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_precGLOB_MSr0BSr0_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;

% (MSr = 1, BSr = 0)
MS_robustification = 1; BS_robustification = 0;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_precGLOB_MSr1BSr0_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;

% (MSr = 0, BSr = 1)
MS_robustification = 0; BS_robustification = 1;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_precGLOB_MSr0BSr1_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;

% (MSr = 1, BSr = 1)
MS_robustification = 1; BS_robustification = 1;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_sumrateSNR_run;
sumrateSNR_precGLOB_MSr1BSr1_maxrate = sumrateSNR_maxrate; clear sumrateSNR_maxrate;
