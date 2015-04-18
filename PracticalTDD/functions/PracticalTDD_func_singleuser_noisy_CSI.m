function [user_rates_intercell_tdma, user_rates_unc, user_rates_intracell_tdma] = ...
	PracticalTDD_func_singleuser_noisy_CSI(H,D,Pt,sigma2r,Pr,sigma2t,Nd,stop_crit,estim_signals)

	% Parameters
	[Mr,Mt,Kr,Kt,~,~] = size(H);

	% Preallocate storage
	V = zeros(Mt,Mt,Kr);

	% Identity receive filters, since we only want the _channel_
	U = zeros(Mr,Mr,Kr); W = zeros(Mr,Mr,Kr);
	for k = 1:Kr
		U(:,:,k) = eye(Mr);
		W(:,:,k) = eye(Mr);
	end
	
	% Transmitter side estimation, assume all stop_crit frames have been used
	% for estimation!
	[~,Hreci_hat] = PracticalTDD_func_BSTGEstim_MMSE_full_global_filters_weights(H,U,W,D,Pr,sigma2t,[],estim_signals,stop_crit);

	
	% Find precoders for all users
	for l = 1:Kt
		Dl = find(D(:,l) == 1)'; Kc = length(Dl);
		
		for k = Dl
			% Get sub channel gains
			[~,DD,VV] = svd(Hreci_hat(:,:,k)');
			DDdiag = diag(DD);
			d2 = [DDdiag.^2;zeros(Mt-length(DDdiag),1)]; s2d2 = sigma2r./d2;

			% Gains s2d2 come out sorted, since the SVD sorts the singular
			% values. I.e., s2d2 starts with the strongest channel, and ends
			% with the weakest. This is important for the order in which we
			% deactivate channels.

			% Start with only activating all channels
			Mg = 1:length(s2d2); 

			while true
				% Find waterlevel
				mu = (1/length(Mg))*(Pt/Kc + sum(s2d2(Mg)));

				% Get new power allocations
				Psub = mu - s2d2(Mg);

				% Is the waterlevel high enough?
				if Psub(end) > 0
					% We can accomodate all subchannels
					break;
				else
					% Not enough power, turn off weakest channel
					Mg(end) = [];
				end
			end

			% Final power allocation
			Palloc = [Psub;zeros(Mt-length(Psub),1)];

			% Precoder
			V(:,:,k) = VV*diag(sqrt(Palloc));
		end
	end
	
	
	% Performance	
	user_rates_intercell_tdma = PracticalTDD_func_intercell_tdma_rate(H,V,D,sigma2r);
	user_rates_unc  = PracticalTDD_func_sdma_rate(H,V,D,sigma2r);
	user_rates_intracell_tdma = PracticalTDD_func_intracell_tdma_rate(H,V,D,sigma2r);

end