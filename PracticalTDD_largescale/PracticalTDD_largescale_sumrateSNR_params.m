clear;


% Simulation parameters
rng('shuffle');			% Replace with non-negative integer for reproducible pseudo-random numbers
sim_params.PRNG_SEED = rng();	% Store seed

sim_params.run_baselines			 = true;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = true;


% Scenario and algorithm parameters
Nnetworks = 1;    % number of user drops to simulate
Nshadow = 1;			% number of shadow fading realizations per user drop
Nsim = 1;         % number of channel realizations, per user drop and shadow fading realization

BW = 15e3;				% One LTE subcarrier is 15 kHz

Pt_dBms = 0:3:21;     % BS transmit power [dBm] ('Standard power' would be 18.2 dBm for 600 subcarriers and 10 MHz)
sigma2r_dBm = -174 + 10*log10(BW) + 9;   % MS noise power over 15 kHz, 9dB noise figure
Pr_dBms = [-4.8 -1.8];   % BS transmit power [dBm] ('Standard power' would be -4.8 dBm for 600 subcarriers and 10 MHz)
sigma2t_dBm = -174 + 10*log10(BW) + 5;   % BS noise power over 15 kHz, 5dB noise figure

channel_model.name = 'triangular_CN01_iid_pathloss_shadow_antenna_gain_pattern';
channel_model.params.inter_site_distance = 500;
channel_model.params.guard_distance = 200;
channel_model.params.alpha = 37.6;
channel_model.params.beta = 15.3;
channel_model.params.shadow_std_dev = 8;
channel_model.params.penetration_loss_dB = 20;

Kt = 3;							% number of transmitters
Kc = 12; Kr = Kt*Kc;	% number of receivers per transmitter, and total number of receivers
Mt = 4;							% number of transmit antennas
Mr = 2;							% number of receive antennas

Nd = 1;							% number of data streams per user

Np = 36;						% number of pilots for the prec scheme

D = kron(eye(Kt),ones(Kc,1));									% user association
Dsched = D; Dsched(2,1) = 0; Dsched(4,2) = 0; % 'scheduling' for MaxSINR

stop_crit = 20;						% number of algorithm iterations

MS_robustification = 1;		% diagonal loading at MS?
BS_robustification = 1;		% power scaling at BS?


% Estimation parameters
estim_params.pilot_type_prec = 'dft';	% 'dft', 'random','random_orthogonal'
estim_params.Npd_prec = Np;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_prec = Np;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.pilot_type_full = 'dft';	% 'dft', 'random','random_orthogonal'
estim_params.Npd_full = Kt*Mt;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_full = Kr*Mr;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec;

estim_params.BS_weight_estimator  = @PracticalTDD_func_BSWEstim_perfect;
estim_params.quantization_bits = 10;
