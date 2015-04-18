function user_rates_e = ...
	PracticalTDD_func_MaxSINR_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit, ...
	estim_params,estim_signals)
	
	% Constants
	MAX_ITERS = 5e3;

	% Parameters
	[Mr,Mt,Kr,Kt,~,~] = size(H);

	% Filter variables
	U = zeros(Mr,Nd,Kr);	  % receive filters
	V = zeros(Mt,Nd,Kr);
	for l = 1:Kt
		Dl = find(D(:,l) == 1)';
		Kc = length(Dl);

		for k = Dl
			Vp = fft(eye(Mt,Nd))/sqrt(Mt);
			V(:,:,k) = sqrt(Pt/Kc)*(Vp/norm(Vp,'fro'));
		end
	end
	
	% Performance evolution variables
	user_rates_e   = zeros(Kr,stop_crit);	% Sum rate evolution
	
	
	% Identity weights
	W = zeros(Nd,Nd,Kr);
	for k = 1:Kr
		W(:,:,k) = eye(Nd);
	end
	

	% Iterate
	iter = 1;
	while (iter <= MAX_ITERS)
		
		% Receiver side estimation
		[Qhat,Fhat] = estim_params.MS_channel_estimator(H,V,D,Pt,sigma2r,estim_signals,iter);
		
		% Find receive filters for all MS k
		for k = 1:Kr
			% BS this MS receives data from
			dinvk = find(D(k,:) == 1);

			% Only update if this MS is served
			if(dinvk)
				
				% Loop over all streams
				for n = 1:Nd
					% Build interference plus noise covariance matrix, for this stream
					Bs = Qhat(:,:,k) - (Fhat(:,n,k)*Fhat(:,n,k)');

					% Update receive filters
					Utmp = Bs\Fhat(:,n,k);
					U(:,n,k) = sqrt(1/sigma2r)*Utmp/norm(Utmp,2);
				end
			end
		end

		
		% Transmitter side estimation
		[That,Ghat] = estim_params.BS_channel_estimator(H,U,W,D,Pr,sigma2t,sigma2r,estim_signals,iter);

		if(isequal(estim_params.BS_channel_estimator,@PracticalTDD_func_BSTGEstim_MMSE_full_global_filters_weights))
			noise_pow_mat = (sigma2r/Pt)*eye(Mt);
		else
			% Slight error here: the noise estimates will be a factor Nd/sigma2r
			% off... Disregard this...
			noise_pow_mat = zeros(Mt);
		end
		
		% Find precoders for all BS l serving users Dl
		for l = 1:Kt
			% MSs this BS serve
			Dl = find(D(:,l) == 1)'; Kc = length(Dl);
			
			% Only update precoder if this BS is transmitting to any user at all
			if(Kc > 0)

				for k = Dl
					% Loop over all streams (N.B., the number of streams is defined
					% from the MS perspective)
					for n = 1:Nd
						% Build interference plus noise covariance matrix, for this stream
						Brs = That(:,:,l) - Ghat(:,n,k)*Ghat(:,n,k)' + noise_pow_mat;

						% Update virtual receive filters (uniform power allocation over users and streams)
						Vtmp = Brs\Ghat(:,n,k);
						V(:,n,k) = sqrt(Pt/(Nd*Kc))*Vtmp/norm(Vtmp,2);
					end
				end
			end

		end % loop over transmitters


		% Calculate sum rate criterion
		user_rates_e(:,iter) = PracticalTDD_func_sdma_rate(H,V,D,sigma2r);

		% Convergence check
		if (iter >= stop_crit)
			break;
		end

		iter = iter + 1;

	end % outer iterations

end