function rates = PracticalTDD_func_intracell_tdma_rate(H,V,D,sigma2r)
	% Parameters
	[Mr,~,Kr,Kt] = size(H);

	% Get covariances
	[Q,F] = PracticalTDD_func_MSQFEstim_perfect(H,V,D,sigma2r);

	% Calculate rates, for scheduled users
	rates = zeros(Kr,1);
	for l = 1:Kt
		Dl = find(D(:,l) == 1)'; Kc = length(Dl);
		
		% Get rates
		for k = Dl
			% Get intracell covariance to subtract
			Q_intra = zeros(Mr,Mr);
			for j = Dl
				Q_intra = Q_intra + H(:,:,k,l)*(V(:,:,j)*V(:,:,j)')*H(:,:,k,l)';
			end
		
			A = (Q(:,:,k) - Q_intra)\(F(:,:,k)*F(:,:,k)'); % intracell TDMA. The BSs always transmit, so no power amplification here. Each F has power Pt/Kc
			rates(k) = (1/Kc)*abs(sum(log2(1 + eig(A)))); % each MS only gets 1/Kc of the time allocated to it
		end
	end
end