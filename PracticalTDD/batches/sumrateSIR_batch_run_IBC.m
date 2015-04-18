clear;


% Save the results?
save_results = true;

% Simulation parameters
rng(1729519190);			% Replace with non-negative integer for reproducible pseudo-random numbers
sim_params.PRNG_SEED = rng();	% Store seed


% Scenario and algorithm parameters
Nsim = 1000;				% number of channel realizations to average over

SNRd_dB = 20;				% signal-to-noise ratio in downlink [dB]
SNRu_dB = 10;				% signal-to-noise ratio in uplink [dB]

SIR_dBs = 0:3:50;	% signal-to-interference ratio in downlink [dB]

Kt = 3;							% number of transmitters
Kc = 2; Kr = Kt*Kc;	% number of receivers per transmitter, and total number of receivers
Mt = 4;							% number of transmit antennas
Mr = 2;							% number of receive antennas

Nd = 1;							% number of data streams per user

D = kron(eye(Kt),ones(Kc,1));									% user association
Dsched = D; %Dsched(2,1) = 0; Dsched(4,2) = 0; % 'scheduling' for MaxSINR

stop_crit = 20;						% number of algorithm iterations




% Estimation parameters
estim_params.pilot_type_prec = 'dft';	% 'random','random_orthogonal'
estim_params.Npd_prec = Kt*Mt;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_prec = Kr*Mr;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.pilot_type_full = 'dft';	% 'random','random_orthogonal'
estim_params.Npd_full = Kt*Mt;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_full = Kr*Mr;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec;

estim_params.BS_weight_estimator  = @PracticalTDD_func_BSWEstim_perfect;


% Set up pilots, noise realizations and results storage
PracticalTDD_sumrateSIR_setup;

% Run it
MS_robustification = 1;		% diagonal loading at MS?
BS_robustification = 1;		% power scaling at BS?

sim_params.run_baselines			 = true;
sim_params.run_noisy_maxrate   = true;
sim_params.run_noisy_maxsinr   = true;

PracticalTDD_sumrateSIR_run;

% Save results
if(save_results)
	save(['sumrateSIR_IBC_' datestr(now,30)]);
end