function [T,G] = PracticalTDD_func_BSTGEstim_perfect(H,U,W,D)
	[~,Mt,Kr,Kt,~,~] = size(H);
	Nd = size(W,1);
	
	T = zeros(Mt,Mt,Kt);
	G = zeros(Mt,Nd,Kr);
	
	for l = 1:Kt
		Dl = find(D(:,l) == 1)'; % MSs served data    by BS l
		
		% Covariance matrix for BS l
		for k = 1:Kr
			T(:,:,l) = T(:,:,l) + H(:,:,k,l)'*(U(:,:,k)*W(:,:,k)*U(:,:,k)')*H(:,:,k,l);
		end
		T(:,:,l) = (T(:,:,l) + T(:,:,l)')/2; % enforce Hermitian
		
		% Effective channels for users belonging to this BS
		for k = Dl
			G(:,:,k) = H(:,:,k,l)'*U(:,:,k)*sqrtm(W(:,:,k));
		end
	end
end