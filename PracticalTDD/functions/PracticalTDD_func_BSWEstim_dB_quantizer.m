function What = PracticalTDD_func_BSWEstim_dB_quantizer(W,Pt,sigma2r,estim_params)
	[Nd,~,Kr] = size(W);
	
	if(Nd ~= 1)
		error('Quantizer only support Nd = 1 so far');
	end
	
	q_bits = estim_params.quantization_bits;
	
	% Quantized weight feedback
	for k = 1:Kr
		q_high = 10*log10((Pt*(estim_params.Hsvmax(k))^2 + sigma2r)/sigma2r); q_low = 0;
		q_step = (q_high - q_low)/(2^q_bits);
		q_vals = floor((10*log10(W) - q_low)/q_step);
		What = 10.^((q_low + q_step*q_vals)/10);
	end
end