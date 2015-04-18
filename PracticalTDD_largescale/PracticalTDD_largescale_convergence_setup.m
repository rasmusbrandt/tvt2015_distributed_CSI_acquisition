% Generate network
if(strcmp(channel_model.name,'triangular_CN01_iid_pathloss_antenna_gain_pattern'))
  network = multicellsim.SyntheticNetworkFactory.triangular_CN01_iid_pathloss_antenna_gain_pattern(Kc,Mr,Mt,channel_model.params.inter_site_distance,channel_model.params.guard_distance,channel_model.params.alpha,channel_model.params.beta,Nsim);
elseif(strcmp(channel_model.name,'triangular_CN01_iid_pathloss_shadow_antenna_gain_pattern'))
  network = multicellsim.SyntheticNetworkFactory.triangular_CN01_iid_pathloss_shadow_antenna_gain_pattern(Kc,Mr,Mt,channel_model.params.inter_site_distance,channel_model.params.guard_distance,channel_model.params.alpha,channel_model.params.beta,Nsim,1,channel_model.params.shadow_std_dev);
end

% Apply penetration loss
if( strcmp(channel_model.name,'triangular_CN01_iid_pathloss_antenna_gain_pattern') || ...
	  strcmp(channel_model.name,'triangular_CN01_iid_pathloss_shadow_antenna_gain_pattern'))
  for l = 1:Kt
    for k = 1:Kr
      for ii_Nt = 1:Nsim
        network.channels{k,l}.coefficients(:,:,ii_Nt,:) = sqrt(10^(-channel_model.params.penetration_loss_dB/10))*network.channels{k,l}.coefficients(:,:,ii_Nt,:);
      end
    end
  end
end

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
