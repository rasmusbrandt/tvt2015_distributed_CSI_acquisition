% Start timing
tstart = tic;

% Consistency check
if(any(sum((D == 1),2) > 1))
	error('Inconsistency in D. We do not allow for joint processing.');
end


% Local shortcuts
C = ones(size(D));
estim_params_perfect = estim_params; estim_params_perfect.BS_weight_estimator  = @PracticalTDD_func_BSWEstim_perfect;


parfor ii_Nsim = 1:Nsim
	ii_Nsim
	
	% Temporary results storage, so the outer parfor will work with the
	% nested loops
	iter_sumrateQres_rates_perfect = zeros(Kr,length(SNRd_dBs),length(SNRu_dBs));
	iter_sumrateQres_rates_quantized = zeros(Kr,length(SNRd_dBs),length(SNRu_dBs),length(quantizer_bits));


	% Get channels
	H = network.as_matrix(ii_Nsim);

	
	% Get current noise realization for the estimators
	estim_signals = raw_estim_signals;
	MS_norm_noise_realizations = raw_estim_signals.MS_norm_noise_realizations; estim_signals.MS_norm_noise_realizations = MS_norm_noise_realizations(:,:,ii_Nsim);
	BS_norm_noise_realizations = raw_estim_signals.BS_norm_noise_realizations; estim_signals.BS_norm_noise_realizations = BS_norm_noise_realizations(:,:,ii_Nsim);
	
	
	
	% Need to have a temporary structure here, to please parfor...
	estim_params_quantized = estim_params;
	estim_params_quantized.BS_weight_estimator = @PracticalTDD_func_BSWEstim_dB_quantizer;
	estim_params_quantized.Hsvmax = zeros(Kr,1);
	for k = 1:Kr
		dinvk = find(D(k,:) == 1);
		estim_params_quantized.Hsvmax(k) = max(svd(H(:,:,k,dinvk)));
	end
				

	% Loop over downlink SNRs
	for ii_SNRd = 1:length(SNRd_dBs)

		% Set up power
		sigma2r = 1; Pt = sigma2r*(10^(SNRd_dBs(ii_SNRd)/10));
		

		% Loop over uplink SNRs
		for ii_SNRu = 1:length(SNRu_dBs)

			% Set up power
			sigma2t = 1; Pr = sigma2t*(10^(SNRu_dBs(ii_SNRu)/10));

			
			% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
			% MaxRate with perfect feedback
			% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
			
			maxrate_rate_e = ...
				PracticalTDD_func_MaxRate_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
					estim_params_perfect,estim_signals,MS_robustification,BS_robustification);
			iter_sumrateQres_rates_perfect(:,ii_SNRd,ii_SNRu) = maxrate_rate_e(:,end);
			
			
			% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
			% MaxRate with quantized feedback
			% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
			
			for ii_bits = 1:length(quantizer_bits)
				estim_params_quantized.quantization_bits = quantizer_bits(ii_bits);
				
				maxrate_rate_e = ...
					PracticalTDD_func_MaxRate_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
						estim_params_quantized,estim_signals,MS_robustification,BS_robustification);
				iter_sumrateQres_rates_quantized(:,ii_SNRd,ii_SNRu,ii_bits) = maxrate_rate_e(:,end);
			end
		end
		
	end

	% Store to permanent storage
	sumrateQres_rates_perfect(:,:,:,ii_Nsim)   = iter_sumrateQres_rates_perfect;
	sumrateQres_rates_quantized(:,:,:,:,ii_Nsim) = iter_sumrateQres_rates_quantized;
end


% Report timing performance
telapsed = toc(tstart);
disp(sprintf('PracticalTDD_sumrateQres_run: %s', seconds2human(telapsed)));


% House keeping
clear ii_Nsim;