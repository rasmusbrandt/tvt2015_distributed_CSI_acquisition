function [V,mu_star] = PracticalTDD_func_MaxRate_noisy_CSI_BSOpt(ThatBS,Ghat,W,Dl,Pt,sigma2r,Pr,sigma2t,Nd,estim_params)
	T_INV_RCOND         = 1e-14; % invertibility criterion
	BIS_TOL             = 1e-3;	 % bisection tolerance
	BIS_MAX_ITERS       = 1e2;	 % max number of bisection iterations
	BIS_LOWER_EIG_MIN		= 1e-10; % minimum eigenvalue after mu_lower addition, for invertibility
	
	
	[Mt,~,Kr] = size(Ghat);
	V = zeros(Mt,Nd,Kr);

	
	% Form matrices and function needed for bisection
	bis_M = zeros(Mt,Mt);
	for k = Dl
		bis_M = bis_M + Ghat(:,:,k)*W(:,:,k)*Ghat(:,:,k)';
	end
	[bis_J,bis_PI] = eig(ThatBS); bis_PI_diag = abs(diag(bis_PI));
	bis_JMJ_diag = abs(diag(bis_J'*bis_M*bis_J)); % abs to remove imaginary noise
	f = @(mu) sum(bis_JMJ_diag./(bis_PI_diag + mu).^2);
				
				
	% Bisection lower bound (deal with noisy estimate of T)
	if(isequal(estim_params.BS_channel_estimator,@PracticalTDD_func_BSTGEstim_LSE_prec))
		mu_lower = -min(min(bis_PI_diag) - BIS_LOWER_EIG_MIN, Nd/(Pr*sigma2r)*sigma2t);
	else
		mu_lower = 0;
	end
	
	% Do we need to do bisection?
	if(rcond(ThatBS + mu_lower*eye(Mt)) > T_INV_RCOND && f(mu_lower) < Pt)
		% No bisection needed
		mu_star = mu_lower;
	else
		% Upper bound, should be feasible and non-negative
		mu_upper = max(sqrt((Mt/Pt)*max(bis_JMJ_diag)) - min(bis_PI_diag),0);
		if(f(mu_upper) > Pt)
			error('Infeasible upper bound.');
		end
		if(mu_upper < mu_lower)
			error('Bad upper bound');
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
		V(:,:,k) = (ThatBS + mu_star*eye(Mt))\(Ghat(:,:,k)*sqrtm(W(:,:,k)));
	end
end
