clear;

% Save the results?
save_results = true;

% Simulation parameters
rng(3276250785);		% Reproducible pseudo-random numbers
sim_params.PRNG_SEED = rng();	% Store seed		


% Scenario and algorithm parameters
Nsim = 1000;				% number of channel realizations to average over

SNRd_dB = 20;				% signal-to-noise ratio in downlink [dB]
SNRu_dB = 10;				% signal-to-noise ratio in uplink [dB]

Kt = 3;							% number of transmitters
Kc = 2; Kr = Kt*Kc;	% number of receivers per transmitter, and total number of receivers
Mt = 4;							% number of transmit antennas
Mr = 2;							% number of receive antennas

Nd = 1;							% number of data streams per user

D = kron(eye(Kt),ones(Kc,1));									% user association
Dsched = D; Dsched(2,1) = 0; Dsched(4,2) = 0; % 'scheduling' for MaxSINR

stop_crit_perfect = 1000;	% number of algorithm iterations for perfect CSI
stop_crit_noisy   = 1000;		% number of algorithm iterations for noisy CSI


% Estimation parameters (equal over-the-air overhead for both estimation schemes)
estim_params.pilot_type_prec = 'dft';	% 'random','random_orthogonal','dft'
estim_params.Npd_prec = Kt*Mt;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_prec = Kr*Mr;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.pilot_type_full = 'dft';	% 'random','random_orthogonal','dft'
estim_params.Npd_full = Kt*Mt;	% number of pilot transmissions for effective channel estimation (downlink)
estim_params.Npu_full = Kr*Mr;	% number of pilot transmissions for effective channel estimation (uplink)

estim_params.BS_weight_estimator  = @PracticalTDD_func_BSWEstim_perfect;


% Run simulations
%convergence_batch_perform_all;
convergence_batch_perform_final;


% Save results
if(save_results)
	save(['convergence_IBC_' datestr(now,30)]);
end