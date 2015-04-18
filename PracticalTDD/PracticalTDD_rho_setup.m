% Generate network
network = multicellsim.SyntheticNetworkFactory.IBC_CN01_iid(Kr,Kt,Mr,Mt,Nsim);


% Generate pilots and normalized noise realizations for training
raw_estim_signals = PracticalTDD_func_generate_raw_estim_signals(Mr,Mt,Kr,Kt,Nd,stop_crit,Nsim,estim_params);
			

% Set up storage containers
rho_maxrate = zeros(Kr,length(rhos),length(SNRu_dBs),Nsim);
