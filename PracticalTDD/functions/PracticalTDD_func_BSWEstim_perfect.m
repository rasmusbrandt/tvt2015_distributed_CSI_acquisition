function What = PracticalTDD_func_BSWEstim_perfect(W,Pt,sigma2r,estim_params)
	% Perfect weight feedback
	% Notice that the weights are only used for local optimization in the
	% calling function, and not distributed between BSs. Contrast this to the 
	% "global weight and norm feedback", where the weights are distributed 
	% between BSs during estimation phase.
	What = W;
end