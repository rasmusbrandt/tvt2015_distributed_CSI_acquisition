% Generate network
network = multicellsim.SyntheticNetworkFactory.IBC_CN01_iid(Kr,Kt,Mr,Mt,Nsim);


% Generate pilots and normalized noise realizations for training
raw_estim_signals = PracticalTDD_func_generate_raw_estim_signals(Mr,Mt,Kr,Kt,Nd,stop_crit,Nsim,estim_params);


% Set up storage containers
sumrateSIR_baseline_maxsinr    = zeros(Kr,length(SIR_dBs),Nsim);
sumrateSIR_baseline_maxrate    = zeros(Kr,length(SIR_dBs),Nsim);
sumrateSIR_baseline_unc        = zeros(Kr,length(SIR_dBs),Nsim);
sumrateSIR_baseline_tdma       = zeros(Kr,length(SIR_dBs),Nsim);
sumrateSIR_baseline_tdma_intra = zeros(Kr,length(SIR_dBs),Nsim);

sumrateSIR_maxrate  = zeros(Kr,length(SIR_dBs),Nsim);
sumrateSIR_maxsinr  = zeros(Kr,length(SIR_dBs),Nsim);
