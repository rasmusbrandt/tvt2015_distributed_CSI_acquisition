function What = PracticalTDD_func_BSWEstim_linear_quantizer(W,Pt,sigma2r,estim_params)
	Wsiz = size(W);
	
	if(Wsiz(1) ~= 1)
		error('Quantizer only support Nd = 1 so far');
	end
	
	q_bits = estim_params.quantization_bits;
	
	% Quantized weight feedback
	for k = 1:Kr
		q_high = (Pt*(estim_params.Hsvmax(k))^2 + sigma2r)/sigma2r; q_low = 1;
		q_step = (q_high - q_low)/(2^q_bits);
		q_vals = floor((W - q_low)/q_step);
		What = q_low + q_step*q_vals;
	end
end