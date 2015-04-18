function raw_estim_signals = PracticalTDD_func_generate_raw_estim_signals(Mr,Mt,Kr,Kt,Nd,stop_crit,Nsim,estim_params)
	
	Npd_prec = estim_params.Npd_prec;
	Npu_prec = estim_params.Npu_prec;
	pilot_type_prec = estim_params.pilot_type_prec;
	
	% Generate pilots for estimation of effective channel
	if strcmp(pilot_type_prec,'dft')
		if(Npd_prec < Kr*Nd)
			error('Unable to orthogonalize downlink pilots (prec).');
		end
		if(Npu_prec < Kr*Nd)
			error('Unable to orthogonalize uplink pilots (prec).');
		end
		
		BS_tmp = fft(eye(Npd_prec)); BS_pilots_prec = BS_tmp(:,1:(Kr*Nd))';
		MS_tmp = fft(eye(Npu_prec)); MS_pilots_prec = MS_tmp(:,1:(Kr*Nd))';
	elseif strcmp(pilot_type_prec,'random_orthogonal')
		if(Npd_prec < Kr*Nd)
			error('Unable to orthogonalize downlink pilots (prec).');
		end
		if(Npu_prec < Kr*Nd)
			error('Unable to orthogonalize uplink pilots (prec).');
		end
		
		BS_pilots_prec = (1/sqrt(2))*(randn(Kr*Nd,Npd_prec) + 1i*randn(Kr*Nd,Npd_prec));
		[Xp_tmp,~] = qr(BS_pilots_prec.'); Xp_tmp = Xp_tmp(:,1:(Kr*Nd)).';
		BS_pilots_prec = sqrt(Npd_prec)*Xp_tmp;
			
		MS_pilots_prec = (1/sqrt(2))*(randn(Kr*Nd,Npu_prec) + 1i*randn(Kr*Nd,Npu_prec));
		[Xp_tmp,~] = qr(MS_pilots_prec.'); Xp_tmp = Xp_tmp(:,1:(Kr*Nd)).';
		MS_pilots_prec = sqrt(Npu_prec)*Xp_tmp;
		
	elseif strcmp(pilot_type_prec,'random')
		BS_pilots_prec = (1/sqrt(2))*(randn(Kr*Nd,Npd_prec) + 1i*randn(Kr*Nd,Npd_prec));
		MS_pilots_prec = (1/sqrt(2))*(randn(Kr*Nd,Npu_prec) + 1i*randn(Kr*Nd,Npu_prec));
	end

	raw_estim_signals.BS_pilots_prec = BS_pilots_prec;
	raw_estim_signals.MS_pilots_prec = MS_pilots_prec;
	
	
	Npd_full = estim_params.Npd_full;
	Npu_full = estim_params.Npu_full;
	pilot_type_full = estim_params.pilot_type_full;
	
	% Generate pilots for estimation of full channel
	if strcmp(pilot_type_prec,'dft')
		if(Npd_full < Kt*Mt)
			error('Unable to orthogonalize downlink pilots (full).');
		end
		if(Npu_full < Kr*Mr)
			error('Unable to orthogonalize uplink pilots (full).');
		end
		
		BS_tmp = fft(eye(Npd_full)); BS_pilots_full = BS_tmp(:,1:(Kt*Mt))';
		MS_tmp = fft(eye(Npu_full)); MS_pilots_full = MS_tmp(:,1:(Kr*Mr))';
	elseif strcmp(pilot_type_full,'random_orthogonal')
		if(Npd_full < Kt*Mt)
			error('Unable to orthogonalize downlink pilots (full).');
		end
		if(Npu_full < Kr*Mr)
			error('Unable to orthogonalize uplink pilots (full).');
		end
		
		BS_pilots_full = (1/sqrt(2))*(randn(Kt*Mt,Npd_full) + 1i*randn(Kt*Mt,Npd_full));
		[Xp_tmp,~] = qr(BS_pilots_full.'); Xp_tmp = Xp_tmp(:,1:(Kt*Mt)).';
		BS_pilots_full = sqrt(Npd_full)*Xp_tmp;
			
		MS_pilots_full = (1/sqrt(2))*(randn(Kr*Mr,Npu_full) + 1i*randn(Kr*Mr,Npu_full));
		[Xp_tmp,~] = qr(MS_pilots_full.'); Xp_tmp = Xp_tmp(:,1:(Kr*Mr)).';
		MS_pilots_full = sqrt(Npu_full)*Xp_tmp;
		
	elseif strcmp(pilot_type_full,'random')
		BS_pilots_full = (1/sqrt(2))*(randn(Kt*Mt,Npd_full) + 1i*randn(Kt*Mt,Npd_full));
		MS_pilots_full = (1/sqrt(2))*(randn(Kr*Mr,Npu_full) + 1i*randn(Kr*Mr,Npu_full));
	end

	raw_estim_signals.BS_pilots_full = BS_pilots_full;
	raw_estim_signals.MS_pilots_full = MS_pilots_full;
	
	
	% Generate noise realizations to be used in both types of estimators
	raw_estim_signals.MS_norm_noise_realizations = (1/sqrt(2))*(randn(Kr*Mr,max(Npd_prec,Npd_full)*stop_crit,Nsim) + 1i*randn(Kr*Mr,max(Npd_prec,Npd_full)*stop_crit,Nsim));
	raw_estim_signals.BS_norm_noise_realizations = (1/sqrt(2))*(randn(Kt*Mt,max(Npu_prec,Npu_full)*stop_crit,Nsim) + 1i*randn(Kt*Mt,max(Npu_prec,Npu_full)*stop_crit,Nsim));
	
end