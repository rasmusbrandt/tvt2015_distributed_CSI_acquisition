% Start timing
tstart = tic;

% Consistency check
if(any(sum((D == 1),2) > 1))
	error('Inconsistency in D. We do not allow for joint processing.');
end

% Set up power
sigma2r = 1; Pt = sigma2r*(10^(SNRd_dB/10));


parfor ii_Nsim = 1:Nsim
	ii_Nsim
	
	% Temporary results storage, so the outer parfor will work with the
	% nested loops
	iter_sumrateSNR_maxrate           = zeros(Kr,length(rhos),length(SNRu_dBs));


	% Get channels
	H = network.as_matrix(ii_Nsim);


	% Get current noise realization for the estimators
	estim_signals = raw_estim_signals;
	MS_norm_noise_realizations = raw_estim_signals.MS_norm_noise_realizations; estim_signals.MS_norm_noise_realizations = MS_norm_noise_realizations(:,:,ii_Nsim);
	BS_norm_noise_realizations = raw_estim_signals.BS_norm_noise_realizations; estim_signals.BS_norm_noise_realizations = BS_norm_noise_realizations(:,:,ii_Nsim);
	
	% Loop over uplink SNRs
	for ii_SNRu = 1:length(SNRu_dBs)
		sigma2t = 1; Pr = sigma2t*(10^(SNRu_dBs(ii_SNRu)/10));
		
		% Loop over rhos
		for ii_Nrho = 1:length(rhos)
			maxrate_rate_e = ...
				PracticalTDD_func_MaxRate_noisy_CSI_rho(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
					estim_params,estim_signals,MS_robustification,rhos(ii_Nrho));
			iter_sumrateSNR_maxrate(:,ii_Nrho,ii_SNRu) = maxrate_rate_e(:,end);
		end
	end


	
	% Store to permanent storage
	rho_maxrate(:,:,:,ii_Nsim) = iter_sumrateSNR_maxrate;
end


% Report timing performance
telapsed = toc(tstart);
disp(sprintf('PracticalTDD_rho_run: %s', seconds2human(telapsed)));


% House keeping
clear ii_Nsim iter ii_SNRd ii_SNRu user_rates_e maxrate_rate_e;