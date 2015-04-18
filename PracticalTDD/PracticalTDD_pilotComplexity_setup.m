% Generate network
network = multicellsim.SyntheticNetworkFactory.IBC_CN01_iid(Kr,Kt,Mr,Mt,Nsim);


% Generate noise realizations for training
MS_norm_noise_realizations = (1/sqrt(2))*(randn(Kr*Mr,Nps(end)*stop_crit,Nsim) + 1i*randn(Kr*Mr,Nps(end)*stop_crit,Nsim));
BS_norm_noise_realizations = (1/sqrt(2))*(randn(Kt*Mt,Nps(end)*stop_crit,Nsim) + 1i*randn(Kt*Mt,Nps(end)*stop_crit,Nsim));
			

% Set up storage containers
pilotComplexity_prec_maxrate = zeros(Kr,length(Nps),Nsim);
pilotComplexity_precGLOB_maxrate = zeros(Kr,length(Nps),Nsim);
pilotComplexity_full_maxrate = zeros(Kr,length(Nps),Nsim);
pilotComplexity_RBWMMSE_flops = zeros(length(Nps),1);
pilotComplexity_prec_flops = zeros(length(Nps),1);
pilotComplexity_precGLOB_flops = zeros(length(Nps),1);
pilotComplexity_full_flops = zeros(length(Nps),1);

