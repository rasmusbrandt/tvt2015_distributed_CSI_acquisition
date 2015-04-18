% Generate network
networks = cell(Nnetworks,1);
if(strcmp(channel_model.name,'triangular_CN01_iid_pathloss_antenna_gain_pattern'))
  for n = 1:Nnetworks
    networks{n} = multicellsim.SyntheticNetworkFactory.triangular_CN01_iid_pathloss_antenna_gain_pattern(Kc,Mr,Mt,channel_model.params.inter_site_distance,channel_model.params.guard_distance,channel_model.params.alpha,channel_model.params.beta,Nsim);
  end
elseif(strcmp(channel_model.name,'triangular_CN01_iid_pathloss_shadow_antenna_gain_pattern'))
  for n = 1:Nnetworks
    networks{n} = multicellsim.SyntheticNetworkFactory.triangular_CN01_iid_pathloss_shadow_antenna_gain_pattern(Kc,Mr,Mt,channel_model.params.inter_site_distance,channel_model.params.guard_distance,channel_model.params.alpha,channel_model.params.beta,Nsim,Nshadow,channel_model.params.shadow_std_dev);
  end
end

% Apply penetration loss
if( strcmp(channel_model.name,'triangular_CN01_iid_pathloss_antenna_gain_pattern') || ...
	  strcmp(channel_model.name,'triangular_CN01_iid_pathloss_shadow_antenna_gain_pattern'))
  for n = 1:Nnetworks
    for l = 1:Kt
      for k = 1:Kr
        networks{n}.channels{k,l}.coefficients = sqrt(10^(-channel_model.params.penetration_loss_dB/10))*networks{n}.channels{k,l}.coefficients;
      end
    end
  end
end


% Generate pilots and normalized noise realizations for training
raw_estim_signals = PracticalTDD_func_generate_raw_estim_signals(Mr,Mt,Kr,Kt,Nd,stop_crit,Nnetworks*Nshadow*Nsim,estim_params);
			

% Set up storage containers
sumrateSNR_baseline_maxsinr  = zeros(Kr,length(Pt_dBms),Nnetworks,Nshadow,Nsim);
sumrateSNR_baseline_maxrate  = zeros(Kr,length(Pt_dBms),Nnetworks,Nshadow,Nsim);
sumrateSNR_baseline_unc      = zeros(Kr,length(Pt_dBms),length(Pr_dBms),Nnetworks,Nshadow,Nsim);
sumrateSNR_baseline_tdma     = zeros(Kr,length(Pt_dBms),length(Pr_dBms),Nnetworks,Nshadow,Nsim);

sumrateSNR_maxrate  = zeros(Kr,length(Pt_dBms),length(Pr_dBms),Nnetworks,Nshadow,Nsim);
sumrateSNR_maxsinr  = zeros(Kr,length(Pt_dBms),length(Pr_dBms),Nnetworks,Nshadow,Nsim);
