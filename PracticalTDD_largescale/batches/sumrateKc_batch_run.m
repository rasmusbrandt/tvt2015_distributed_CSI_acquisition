clear;

% Save the results?
save_results = true;

% Simulation parameters
rng(383987236);
sim_params.PRNG_SEED = rng();	% Store seed

sim_params.run_baselines			 = true;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = true;


% Scenario and algorithm parameters
Kcs = 1:10;
Nnetworks = 500;   % number of user drops to simulate
Nshadow = 1;			% number of shadow fading realizations per user drop
Nsim = 5;         % number of channel realizations, per user drop and shadow fading realization

BW = 15e3;				% One LTE subcarrier is 15 kHz
Nc = 600;					% 600 subcarriers over a band of 10 MHz

Pt_dBm = 10*log10(10^(46/10)/Nc);        % BS transmit power [dBm] ('Standard' LTE BS transmit power is 46 dBm over the entire band. Here we assume 600 subcarriers and 10 MHz)
sigma2r_dBm = -174 + 10*log10(BW) + 9;   % MS noise power over 15 kHz, 9dB noise figure
Pr_dBm = 10*log10(10^(23/10)/Nc);        % BS transmit power [dBm] ('Standard' LTE UE transmit power is 23 dBm. See above.)
sigma2t_dBm = -174 + 10*log10(BW) + 5;   % BS noise power over 15 kHz, 5dB noise figure

channel_model.name = 'triangular_CN01_iid_pathloss_shadow_antenna_gain_pattern';
channel_model.params.inter_site_distance = 500; % Case 1 3GPP
channel_model.params.guard_distance = 200;
channel_model.params.alpha = 37.6;
channel_model.params.beta = 15.3;
channel_model.params.shadow_std_dev = 8; % Standard 8 dB standard deviation on shadow fading
channel_model.params.penetration_loss_dB = 20; % Case 1 3GPP mandates 20 dB penetration loss

Kt = 3;							% number of transmitters
Kr_max = Kt*max(Kcs);
Mt = 4;							% number of transmit antennas
Mr = 2;							% number of receive antennas

Nd = 1;							% number of data streams per user

Np = Kr_max*Nd;	% number of pilots for the prec scheme

maxrate_max_scheduled_users = 10;
maxsinr_max_scheduled_users = 2;

stop_crit = 20;						% number of algorithm iterations


% Estimation parameters
estim_params.pilot_type_prec = 'dft';	% 'dft', 'random','random_orthogonal'
estim_params.Npd_prec = Np;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_prec = Np;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec;
estim_params.BS_weight_estimator  = @PracticalTDD_func_BSWEstim_perfect;


% This selection of Npd_full and Npu_full are actually unfair. They imply a 3dB power gain compared to the prec estimators.
estim_params.pilot_type_full = 'dft';	% 'dft', 'random','random_orthogonal'
estim_params.Npd_full = Kt*Mt;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_full = Kr_max*Mr;	% number of pilot transmissions for effective channel estimation (uplink)


% Set up pilots, noise realizations and results storage
PracticalTDD_largescale_sumrateKc_setup;


% (MSr = 1, BSr = 1) and baselines
MS_robustification = 1; BS_robustification = 1;

sim_params.run_baselines			 = true;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = true;
PracticalTDD_largescale_sumrateKc_run;
sumrateKc_prec_baseline_tdma_inter = sumrateKc_baseline_tdma_inter; clear sumrateKc_baseline_tdma_inter;
sumrateKc_prec_baseline_tdma_intra = sumrateKc_baseline_tdma_intra; clear sumrateKc_baseline_tdma_intra;
sumrateKc_prec_baseline_unc  = sumrateKc_baseline_unc; clear sumrateKc_baseline_unc;
sumrateKc_prec_maxsinr = sumrateKc_maxsinr; clear sumrateKc_maxsinr;
sumrateKc_prec_MSr1BSr1_maxrate = sumrateKc_maxrate; clear sumrateKc_maxrate;

% (MSr = 0, BSr = 0)
MS_robustification = 0; BS_robustification = 0;

sim_params.run_baselines			 = false;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = false;
PracticalTDD_largescale_sumrateKc_run;
sumrateKc_prec_MSr0BSr0_maxrate = sumrateKc_maxrate; clear sumrateKc_maxrate;

% Save results
if(save_results)
	save(['sumrateKc_' datestr(now,30)]);
end
