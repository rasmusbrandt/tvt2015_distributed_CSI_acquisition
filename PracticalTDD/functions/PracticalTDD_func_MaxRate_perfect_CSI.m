function [user_rates_e,UWsqrt_e,U_e,W_e,V_e,mu_e,TEMP] = ...
	PracticalTDD_func_MaxRate_perfect_CSI(H,D,Pt,sigma2r,Nd,stop_crit)
	
	% Constants
	MAX_ITERS           = 5e3;
	T_INV_RCOND         = 1e-14;
	BIS_TOL             = 1e-3;
	BIS_MAX_ITERS       = 1e2;
	

	% Parameters
	[Mr,Mt,Kr,Kt,~,~] = size(H);

	
	% Filter variables
	U = zeros(Mr,Nd,Kr); % receive filters
	W = zeros(Nd,Nd,Kr); % weights
	V = zeros(Mt,Nd,Kr); % transmit filters
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
	UWsqrt_e = zeros(Kr,stop_crit);	% ||UW^(1/2)||^2 evolution
	U_e		   = zeros(Kr,stop_crit); % ||U||^2 evolution
	W_e		   = zeros(Kr,stop_crit); % tr(W) evolution
	V_e		   = zeros(Kr,stop_crit); % ||V||^2 evolution
	mu_e		 = zeros(Kt,stop_crit); % mu evolution
	
	TEMP = zeros(Kr,stop_crit);
	
	% Iterate
	iter = 1;
	while (iter <= MAX_ITERS)
		
		% Receiver side estimation
		[Q,F] = PracticalTDD_func_MSQFEstim_perfect(H,V,D,sigma2r);
		
		% Find receive filters for all MS k
		for k = 1:Kr
			% Only update if this MS is served
			if(any(D(k,:)))
				
				% New receive filter
				U(:,:,k) = Q(:,:,k)\F(:,:,k);
				
				% Get new MMSE weights
				W(:,:,k) = inv(eye(Nd) - U(:,:,k)'*F(:,:,k));
				W(:,:,k) = (W(:,:,k) + W(:,:,k)')/2;
				
				% Get user rates
				if(iter ~= 1)
					user_rates_e(k,iter-1) = sum(log2(eig(W(:,:,k))));
				end
			end
		end
		
		% Transmitter side estimation
		[T,G] = PracticalTDD_func_BSTGEstim_perfect(H,U,W,D);

		% Find precoders for all BS l serving users Dl
		for l = 1:Kt
			
			% Only update precoders if this BS serves any MS at all
			if(any(D(:,l)))
				
				% MSs served by this BS
				Dl = find(D(:,l) == 1)';
				
				% Form matrices and function needed for bisection
				bis_M = zeros(Mt,Mt);
				for k = Dl
					bis_M = bis_M + G(:,:,k)*W(:,:,k)*G(:,:,k)';
				end
				[bis_J,bis_PI] = eig(T(:,:,l)); bis_PI_diag = abs(diag(bis_PI));
				bis_JMJ_diag = abs(diag(bis_J'*bis_M*bis_J)); % abs to remove imaginary noise
				f = @(mu) sum(bis_JMJ_diag./(bis_PI_diag + mu).^2);
					
				
				% Bisection lower bound
				mu_lower = 0;
	
				% Do we need to do bisection?
				if(rcond(T(:,:,l)) > T_INV_RCOND && f(mu_lower) < Pt)
					% No bisection needed
					mu_star = mu_lower;
				else
					% Upper bound, should be feasible
					mu_upper = sqrt((Mt/Pt)*max(bis_JMJ_diag)) - min(bis_PI_diag);
					if(f(mu_upper) > Pt)
						error('Infeasible upper bound.');
					end

					bis_iters = 1;
					while(bis_iters <= BIS_MAX_ITERS)
						mu = (1/2)*(mu_lower + mu_upper);

						if(f(mu) < Pt)
							% New point was feasible, replace upper point
							conv_crit = abs(mu - mu_upper)/abs(mu_upper);
							mu_upper = mu;
						else
							% New point was not feasible, replace lower point
							conv_crit = abs(mu - mu_lower)/abs(mu_lower);
							mu_lower = mu;
						end

						% Convergence check
						if ((conv_crit < BIS_TOL) || bis_iters == BIS_MAX_ITERS)
							mu_star = mu_upper; % Use the upper point, so we know it is feasible
							break;
						end

						bis_iters = bis_iters + 1;
					end
					
					if(bis_iters == BIS_MAX_ITERS)
						warning('Bisection reached max iterations.');
					end
				end
				
				% Find precoders
				for k = Dl
					V(:,:,k) = (T(:,:,l) + mu_star*eye(Mt))\(G(:,:,k)*sqrtm(W(:,:,k)));
				end

				% Store Lagrange multiplier
				mu_e(l,iter) = mu_star;
				
				
% 				% TEMP
% 				for k = Dl
% 					B = V(:,:,k)*inv(sqrtm(W(:,:,k))); Wt = eye(Nd) + G(:,:,k)'*inv(T(:,:,l) - G(:,:,k)*G(:,:,k)' + mu_star*eye(Mt))*G(:,:,k);
% 					TEMP(k,iter) = abs(trace(B*Wt*B'));
% 				end
				
			end % if(any(D(:,l)))
		end % loop over transmitters

		% Calculate evolution measures
		for k = 1:Kr
			if sum(sum(W(:,:,k))) ~= 0
				UWsqrt_e(k,iter) = norm(U(:,:,k)*sqrtm(W(:,:,k)),'fro')^2;
			end
			U_e(k,iter)			 = norm(U(:,:,k),'fro')^2;
			W_e(k,iter)			 = trace(W(:,:,k));
			V_e(k,iter)		   = norm(V(:,:,k),'fro')^2;
		end

		% Convergence check
		if (iter >= stop_crit)
			break;
		end

		iter = iter + 1;

	end % outer iterations
	
	% Final rate evolution
	user_rates_e(:,stop_crit) = PracticalTDD_func_sdma_rate(H,V,D,sigma2r);

end