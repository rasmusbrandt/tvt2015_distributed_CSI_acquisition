% Generate network
network = multicellsim.SyntheticNetworkFactory.IBC_CN01_iid(Kr,Kt,Mr,Mt,Nsim); 


% Generate pilots and normalized noise realizations for training
raw_estim_signals = PracticalTDD_func_generate_raw_estim_signals(Mr,Mt,Kr,Kt,Nd,stop_crit,Nsim,estim_params);
			

% Set up storage containers
sumrateQres_rates_perfect    = zeros(Kr,length(SNRd_dBs),length(SNRu_dBs),Nsim);
sumrateQres_rates_quantized  = zeros(Kr,length(SNRd_dBs),length(SNRu_dBs),length(quantizer_bits),Nsim);