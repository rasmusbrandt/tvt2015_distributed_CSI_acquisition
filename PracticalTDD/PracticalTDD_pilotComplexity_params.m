clear;


% Simulation parameters
rng('shuffle');			% Replace with non-negative integer for reproducible pseudo-random numbers
sim_params.PRNG_SEED = rng();	% Store seed


% Scenario and algorithm parameters
Nsim = 32;					% number of channel realizations to average over

SNRd_dB = 20;	% signal-to-noise ratios in downlink [dB]
SNRu_dB = 10;	% signal-to-noise ratios in uplink [dB]

Kt = 3;							% number of transmitters
Kc = 2; Kr = Kt*Kc;	% number of receivers per transmitter, and total number of receivers
Mt = 4;							% number of transmit antennas
Mr = 2;							% number of receive antennas

Nd = 1;							% number of data streams per user

D = kron(eye(Kt),ones(Kc,1));	% user association

stop_crit = 20;								% number of algorithm iterations

Nps = max(Kt*Mt,Kr*Mr):4:100; % number of pilots (uplink and downlink)


% Estimation parameters
estim_params.pilot_type_prec = 'dft';	% 'random','random_orthogonal'
estim_params.pilot_type_full = 'dft';	% 'random','random_orthogonal'

estim_params.BS_weight_estimator  = @PracticalTDD_func_BSWEstim_perfect;
