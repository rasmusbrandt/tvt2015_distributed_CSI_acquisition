iters = 1:stop_crit_noisy;

% Sum rate evolution
figure;
plot(iters, sum(mean(convergence_maxrate_rates_perfect(:,1:stop_crit_noisy,:),3),1), 'b-',  ...
	   iters, sum(mean(convergence_maxrate_rates_noisy,3),1),   'b--', ...
		 iters, sum(mean(convergence_maxsinr_rates_perfect(:,1:stop_crit_noisy,:),3),1), 'r-',  ...
	   iters, sum(mean(convergence_maxsinr_rates_noisy,3),1),   'r--', ...
		 iters, sum(mean(convergence_baseline_tdma,2))*ones(size(iters)),    'c-', ...
	   iters, sum(mean(convergence_baseline_unc,2))*ones(size(iters)),  'k-',  ...
		 iters, sum(mean(convergence_maxrate_rates_perfect(:,end,:),3))*ones(size(iters)), 'b:',  ...
		 iters, sum(mean(convergence_maxsinr_rates_perfect(:,end,:),3))*ones(size(iters)), 'r:');
legend('MaxRate Perfect', 'MaxRate noisy','MaxSINR Perfect', 'MaxSINR noisy', 'TDMA WF','Uncoord. WF', 'MaxRate UB', 'MaxSINR UB', 'Location','SouthEast');
xlabel('Iteration no.'); ylabel('Sum rate [bits/s/Hz]');
title(sprintf('Nsim = %d, SNRd = %d [dB], SNRu = %d [dB], Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d, BS\\_r = %d',Nsim,SNRd_dB,SNRu_dB,Kt,Kc,Mt,Mr,Nd,MS_robustification,BS_robustification));


% User rates evolution
figure;
subplot(2,2,1);
plot(1:stop_crit_perfect, mean(convergence_maxrate_rates_perfect,3));
xlabel('Iteration no.'); ylabel('Perfect MaxRate');

subplot(2,2,2);
plot(1:stop_crit_noisy, mean(convergence_maxrate_rates_noisy,3));
xlabel('Iteration no.'); ylabel('Noisy MaxRate');

subplot(2,2,3); hold on;
p1 = plot(1:stop_crit_perfect, mean(convergence_maxsinr_rates_perfect,3));
xlabel('Iteration no.'); ylabel('Perfect MaxSINR');
legend([p1(1)], 'MaxSINR');

subplot(2,2,4);
plot(1:stop_crit_noisy, mean(convergence_maxsinr_rates_noisy,3));
xlabel('Iteration no.'); ylabel('Noisy MaxSINR');



if(Nsim == 1)
	% Filter evolution
	figure;
	subplot(6,2,1);
	plot(1:stop_crit_perfect, 10*log10(mean(convergence_maxrate_UWsqrt_perfect,3)));
	ylabel('||UW^{1/2}||^2 [dB]'); title('Perfect');

	subplot(6,2,2);
	plot(1:stop_crit_noisy, 10*log10(mean(convergence_maxrate_UWsqrt_noisy,3)));
	ylabel('||UW^{1/2}||^2 [dB]'); title('Noisy');

	subplot(6,2,3);
	plot(1:stop_crit_perfect, 10*log10(mean(convergence_maxrate_U_perfect,3)));
	ylabel('||U||^2 [dB]');

	subplot(6,2,4);
	plot(1:stop_crit_noisy, 10*log10(mean(convergence_maxrate_U_noisy,3)));
	ylabel('||U||^2 [dB]');

	subplot(6,2,5);
	plot(1:stop_crit_perfect, 10*log10(mean(convergence_maxrate_W_perfect,3)));
	ylabel('tr(W) [dB]');

	subplot(6,2,6);
	plot(1:stop_crit_noisy, 10*log10(mean(convergence_maxrate_W_noisy,3)));
	ylabel('tr(W) [dB]');

	subplot(6,2,7);
	plot(1:stop_crit_perfect, 10*log10(mean(convergence_maxrate_V_perfect,3)));
	ylabel('||V||^2 [dB]');

	subplot(6,2,8);
	plot(1:stop_crit_noisy, 10*log10(mean(convergence_maxrate_V_noisy,3)));
	ylabel('||V||^2 [dB]');

	subplot(6,2,9);
	plot(1:stop_crit_perfect, mean(convergence_maxrate_mu_perfect,3));
	ylabel('\mu');

	subplot(6,2,10);
	plot(1:stop_crit_noisy, mean(convergence_maxrate_mu_noisy,3));
	ylabel('\mu');

	subplot(6,2,12);
	plot(1:stop_crit_noisy, mean(convergence_maxrate_nu_noisy,3));
	ylabel('\nu');
	xlabel('Iteration no.');
end