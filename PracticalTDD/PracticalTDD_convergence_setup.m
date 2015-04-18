% Generate network
network = multicellsim.SyntheticNetworkFactory.IBC_CN01_iid(Kr,Kt,Mr,Mt,Nsim); 


% Generate pilots and normalized noise realizations for training
raw_estim_signals = PracticalTDD_func_generate_raw_estim_signals(Mr,Mt,Kr,Kt,Nd,stop_crit_noisy,Nsim,estim_params);


% Set up storage containers
convergence_baseline_unc      = zeros(Kr,Nsim);
convergence_baseline_tdma     = zeros(Kr,Nsim);

convergence_maxrate_rates_perfect    = zeros(Kr,stop_crit_perfect,Nsim);
convergence_maxrate_UWsqrt_perfect   = zeros(Kr,stop_crit_perfect,Nsim);
convergence_maxrate_U_perfect        = zeros(Kr,stop_crit_perfect,Nsim);
convergence_maxrate_W_perfect        = zeros(Kr,stop_crit_perfect,Nsim);
convergence_maxrate_V_perfect        = zeros(Kr,stop_crit_perfect,Nsim);
convergence_maxrate_mu_perfect       = zeros(Kt,stop_crit_perfect,Nsim);

convergence_maxrate_rates_noisy      = zeros(Kr,stop_crit_noisy,Nsim);
convergence_maxrate_UWsqrt_noisy     = zeros(Kr,stop_crit_noisy,Nsim);
convergence_maxrate_U_noisy          = zeros(Kr,stop_crit_noisy,Nsim);
convergence_maxrate_W_noisy          = zeros(Kr,stop_crit_noisy,Nsim);
convergence_maxrate_V_noisy          = zeros(Kr,stop_crit_noisy,Nsim);
convergence_maxrate_mu_noisy         = zeros(Kt,stop_crit_noisy,Nsim);
convergence_maxrate_nu_noisy         = zeros(Kr,stop_crit_noisy,Nsim);

convergence_maxsinr_rates_perfect    = zeros(Kr,stop_crit_perfect,Nsim);
convergence_maxsinr_rates_noisy      = zeros(Kr,stop_crit_noisy,Nsim);
