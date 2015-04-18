% Generate network
network = multicellsim.SyntheticNetworkFactory.IBC_CN01_iid(Kr,Kt,Mr,Mt,Nsim);


% Generate pilots and normalized noise realizations for training
raw_estim_signals = PracticalTDD_func_generate_raw_estim_signals(Mr,Mt,Kr,Kt,Nd,stop_crit,Nsim,estim_params);
			

% Set up storage containers
sumrateSNR_baseline_maxsinr  = zeros(Kr,length(SNRd_dBs),Nsim);
sumrateSNR_baseline_maxrate  = zeros(Kr,length(SNRd_dBs),Nsim);
sumrateSNR_baseline_unc      = zeros(Kr,length(SNRd_dBs),length(SNRu_dBs),Nsim);
sumrateSNR_baseline_tdma     = zeros(Kr,length(SNRd_dBs),length(SNRu_dBs),Nsim);

sumrateSNR_maxrate = zeros(Kr,length(SNRd_dBs),length(SNRu_dBs),Nsim);
sumrateSNR_maxsinr = zeros(Kr,length(SNRd_dBs),length(SNRu_dBs),Nsim);
