function rates = PracticalTDD_func_intercell_tdma_rate(H,V,D,sigma2r)
	% Parameters
	[~,~,Kr_max,Kt] = size(H);
	
	Kr = sum(sum(D)); % Actually scheduled users

	% Get covariances
	[~,F] = PracticalTDD_func_MSQFEstim_perfect(H,V,D,sigma2r);

	% Calculate rates, for scheduled users
	rates = zeros(Kr_max,1);
	for l = 1:Kt
		Dl = find(D(:,l) == 1)';
		
		for k = Dl
			A = (F(:,:,k)*Kt*F(:,:,k)')/sigma2r; % intercell TDMA, so each BS only transmits 1/Kt of the time. Each F has power Pt/Kc
			rates(k) = (1/Kr)*abs(sum(log2(1 + eig(A)))); % each MS only gets 1/Kr of the time allocated to it
		end
	end
end