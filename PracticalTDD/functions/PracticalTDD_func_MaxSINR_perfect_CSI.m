function user_rates_e = ...
	PracticalTDD_func_MaxSINR_perfect_CSI(H,D,Pt,sigma2r,Nd,stop_crit)
	
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
		[Q,F] = PracticalTDD_func_MSQFEstim_perfect(H,V,D,sigma2r);
		
		% Find receive filters for all MS k
		for k = 1:Kr
			% BS this MS receives data from
			dinvk = find(D(k,:) == 1);

			% Only update if this MS is served
			if(dinvk)
				
				% Loop over all streams
				for n = 1:Nd
					% Original MaxSINR: Build interference plus noise covariance matrix, for this stream
					Bs = Q(:,:,k) - (F(:,n,k)*F(:,n,k)');
					
					% Modified MaxSINR: Use total covariance matrix instead
					% (equivalent under no mismatch, see Cox 1973)
					% Bs = Q(:,:,k);

					% Update receive filters
					Utmp = Bs\F(:,n,k);
					U(:,n,k) = Utmp/norm(Utmp,2);
				end
			end
		end

		
		% Transmitter side estimation
		[T,G] = PracticalTDD_func_BSTGEstim_perfect(H,U,W,D);
		
		
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
						% Original MaxSINR: Build interference plus noise covariance matrix, for this stream
						Brs = T(:,:,l) - (G(:,n,k)*G(:,n,k)') + (sigma2r/Pt)*eye(Mt);
						
						% Modified MaxSINR: Use total covariance matrix instead
						% (equivalent under no mismatch, see Cox 1973)
						% Brs = T(:,:,l);

						% Update virtual receive filters (uniform power allocation over users and streams)
						Vtmp = Brs\G(:,n,k);
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