clear;

% Save the results?
save_results = true;

% Simulation parameters
rng(1801986826);			% Replace with non-negative integer for reproducible pseudo-random numbers
sim_params.PRNG_SEED = rng();	% Store seed


% Scenario and algorithm parameters
Nsim = 1000;				% number of channel realizations to average over

SNRd_dBs = 30;			% signal-to-noise ratios in downlink [dB]
SNRu_dBs = 0:10:30;	% signal-to-noise ratios in uplink [dB]

Kt = 3;							% number of transmitters
Kc = 2; Kr = Kt*Kc;	% number of receivers per transmitter, and total number of receivers
Mt = 4;							% number of transmit antennas
Mr = 2;							% number of receive antennas

Nd = 1;							% number of data streams per user

D = kron(eye(Kt),ones(Kc,1));	% user association

stop_crit = 20;								% number of algorithm iterations

MS_robustification = 1;				% diagonal loading at MS?
BS_robustification = 1;				% power scaling at BS?


% Estimation parameters
estim_params.pilot_type_prec = 'dft';	% 'random','random_orthogonal'
estim_params.Npd_prec = Kr*Nd;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_prec = Kr*Nd;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.pilot_type_full = 'dft';	% 'random','random_orthogonal'
estim_params.Npd_full = Kt*Mt;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_full = Kr*Mr;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.MS_channel_estimator = @PracticalTDD_func_MSQFEstim_LSE_prec;
estim_params.BS_channel_estimator = @PracticalTDD_func_BSTGEstim_LSE_prec;

quantizer_bits = 1:8;


% Set up pilots, noise realizations and results storage
PracticalTDD_sumrateQres_setup;

% Run first version
PracticalTDD_sumrateQres_run;
sumrateQres_rates_perfect_SNRd_dB40 = sumrateQres_rates_perfect; clear sumrateQres_rates_perfect;
sumrateQres_rates_quantized_SNRd_dB40 = sumrateQres_rates_quantized; clear sumrateQres_rates_quantized;
SNRd_dBs_tr1 = SNRd_dBs;
SNRu_dBs_tr1 = SNRu_dBs;


% Transpose SNRs
SNRd_dBs = 0:10:30;
SNRu_dBs = 30;
PracticalTDD_sumrateQres_run;
sumrateQres_rates_perfect_SNRu_dB40 = sumrateQres_rates_perfect; clear sumrateQres_rates_perfect;
sumrateQres_rates_quantized_SNRu_dB40 = sumrateQres_rates_quantized; clear sumrateQres_rates_quantized;
SNRd_dBs_tr2 = SNRd_dBs; clear SNRd_dBs;
SNRu_dBs_tr2 = SNRu_dBs; clear SNRu_dBs;

% Save results
if(save_results)
	save(['sumrateQres_IBC_' datestr(now,30)]);
end