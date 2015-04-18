function [U,W,nu_star] = PracticalTDD_func_MaxRate_noisy_CSI_MSOpt(Qhat,Fhat,sigma2r,Nd,MS_robustification)
	BIS_TOL             = 1e-3;
	BIS_MAX_ITERS       = 1e2;
	
	
	Mr = size(Fhat,1);
		
	% Form matrices and function needed for bisection
	[bis_L,bis_LA] = eig(Qhat); [bis_Lin,bis_LAin] = eig(Qhat - Fhat*Fhat');
	bis_A_diag = abs(diag(bis_L'*(Fhat*Fhat')*bis_L)); bis_LA_diag = abs(diag(bis_LA));
	bis_Ain = bis_L'*(Fhat*Fhat')*bis_Lin; bis_LAin_diag = abs(diag(bis_LAin));
	f = @(nu) sum(bis_A_diag./(bis_LA_diag + nu).^2) + norm(((1./(bis_LA_diag + nu))*((1./sqrt(bis_LAin_diag + nu))')).*bis_Ain,'fro')^2;
	
			
	% Bisection lower bound
	nu_lower = 0;
	
	% Robustifying diagonal loading needed?
	if(~MS_robustification || (f(nu_lower) < Nd/sigma2r))
		nu_star = nu_lower;
	else
		% Upper bound, should be infeasible
		% Should actually be rho*sigma2r <= sigma2r, but no loss in having it larger
		nu_upper = sigma2r;
									
		bis_iters = 1;
		while(bis_iters <= BIS_MAX_ITERS)
			nu_middle = (1/2)*(nu_lower + nu_upper);

			if( f(nu_middle) < Nd/sigma2r )
				% Feasible, replace upper point
				conv_crit = abs(nu_middle - nu_upper)/abs(nu_upper);
				nu_upper = nu_middle;
			else
				% Infeasible, replace lower point
				conv_crit = abs(nu_middle - nu_lower)/abs(nu_lower);
				nu_lower = nu_middle;
			end

			if(conv_crit < BIS_TOL)
				nu_star = nu_upper; % Use the upper point, so we know it is feasible
				break;
			end

			bis_iters = bis_iters + 1;
		end

		if(bis_iters == BIS_MAX_ITERS + 1)
			warning('Bisection reached max iterations.');
		end
	end

	
	U = (Qhat + nu_star*eye(Mr))\Fhat;

	W = inv(eye(Nd) - Fhat'*U);
	W = (W + W')/2;
end