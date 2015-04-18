function [Q,F] = PracticalTDD_func_MSQFEstim_perfect(H,V,D,sigma2r)
	[Mr,~,Kr,Kt,~,~] = size(H);
	Nd = size(V,2);

	Q = zeros(Mr,Mr,Kr);
	F = zeros(Mr,Nd,Kr);
	
	for k = 1:Kr
		dinvk = find(D(k,:) == 1);

		if(dinvk)
			% Signal, interference and noise covariance matrix for MS k
			Q(:,:,k) = sigma2r*eye(Mr);
			for l = 1:Kt
				% MSs this BS serve
				Dl = find(D(:,l) == 1)';

				for j = Dl % Loop over all precoders for BS l
					Q(:,:,k) = Q(:,:,k) + H(:,:,k,l)*(V(:,:,j)*V(:,:,j)')*H(:,:,k,l)';
				end
			end
			Q(:,:,k) = (Q(:,:,k) + Q(:,:,k)')/2; % for numerical reasons

			% Effective channel
			F(:,:,k) = H(:,:,k,dinvk)*V(:,:,k);
		end
	end
end