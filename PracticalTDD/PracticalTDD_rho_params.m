clear;


% Simulation parameters
rng('shuffle');			% Replace with non-negative integer for reproducible pseudo-random numbers
sim_params.PRNG_SEED = rng();	% Store seed


% Scenario and algorithm parameters
Nsim = 4;						% number of channel realizations to average over

rhos = logspace(-4,0,40); % Power scaling factor at BS

SNRd_dB = 30;				% signal-to-noise ratio in downlink [dB]
SNRu_dBs = 0:5:30;	% signal-to-noise ratios in uplink [dB]

Kt = 3;							% number of transmitters
Kc = 2; Kr = Kt*Kc;	% number of receivers per transmitter, and total number of receivers
Mt = 4;							% number of transmit antennas
Mr = 2;							% number of receive antennas

Nd = 1;							% number of data streams per user

D = kron(eye(Kt),ones(Kc,1));									% user association

stop_crit = 20;						% number of algorithm iterations

MS_robustification = 1;		% diagonal loading at MS?


% Estimation parameters
estim_params.pilot_type_prec = 'dft';	% 'random','random_orthogonal'
estim_params.Npd_prec = Kr*Nd;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_prec = Kr*Nd;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.pilot_type_full = 'dft';	% 'random','random_orthogonal'
estim_params.Npd_full = Kt*Mt;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_full = Kr*Mr;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec;

estim_params.BS_weight_estimator  = @PracticalTDD_func_BSWEstim_perfect;
