function rates = PracticalTDD_func_sdma_rate(H,V,D,sigma2r)
	% Parameters
	[~,~,Kr,~] = size(H);

	% Get covariances
	[Q,F] = PracticalTDD_func_MSQFEstim_perfect(H,V,D,sigma2r);

	% Calculate rates, for scheduled users
	rates = zeros(Kr,1);
	for k = find(any(D'))
		A = (Q(:,:,k) - F(:,:,k)*F(:,:,k)')\(F(:,:,k)*F(:,:,k)');
		rates(k) = abs(sum(log2(1 + eig(A))));
	end
end