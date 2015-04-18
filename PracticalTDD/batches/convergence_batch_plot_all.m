iters = 1:stop_crit_noisy;


% FULL

% Baselines
figure; hold on;
p1 = plot(iters,mean(sum(convergence_perfect_maxrate(:,end,:),1))*ones(size(iters)),'b:');
p2 = plot(iters,mean(sum(convergence_perfect_maxrate(:,1:stop_crit_noisy,:),1),3),'b-');
p3 = plot(iters,mean(sum(convergence_perfect_maxsinr(:,end,:),1))*ones(size(iters)),'r:');
p4 = plot(iters,mean(sum(convergence_perfect_maxsinr(:,1:stop_crit_noisy,:),1),3),'r-');
p5 = plot(iters,mean(sum(convergence_full_maxsinr(:,1:stop_crit_noisy,:),1),3),'r--');
p6 = plot(iters,mean(sum(convergence_full_baseline_tdma,1),2)*ones(size(iters)),'c-');
p7 = plot(iters,mean(sum(convergence_full_baseline_unc,1),2)*ones(size(iters)),'k-');
title('Full Baselines');
legend([p1(1), p2(1), p3(1), p4(1), p5(1), p6(1), p7(1)], 'Perfect WMMSE (100 iters)', 'Perfect WMMSE', 'Perfect MaxSINR (100 iters)', 'Perfect MaxSINR', 'MaxSINR estim. CSI', 'TDMA estim. CSI', 'UNC estim. CSI', 'Location', 'SE');
xlabel('Iteration no.'); ylabel('Sum rate [bits/s/Hz]');

% RB-WMMSE and traditional robust
figure; hold on;
p0 = plot(iters,mean(sum(convergence_full_tradrobust_maxrate,1),3),'k-^');
p1 = plot(iters,mean(sum(convergence_full_MSr1BSr1_maxrate,1),3),'b-^');
p2 = plot(iters,mean(sum(convergence_full_MSr1BSr0_maxrate,1),3),'r-o');
p3 = plot(iters,mean(sum(convergence_full_MSr0BSr1_maxrate,1),3),'c-s');
p4 = plot(iters,mean(sum(convergence_full_MSr0BSr0_maxrate,1),3),'m-v');
title('Full RB-WMMSE');
legend([p0(1), p1(1), p2(1), p3(1), p4(1)], 'Traditional robust', 'MSr1BSr1', 'MSr1BSr0', 'MSr0BSr1', 'MSr0BSr0', 'Location','SE');
xlabel('Iteration no.'); ylabel('Sum rate [bits/s/Hz]');



% PREC

% Baselines
figure; hold on;
p1 = plot(iters,mean(sum(convergence_perfect_maxrate(:,end,:),1))*ones(size(iters)),'b:');
p2 = plot(iters,mean(sum(convergence_perfect_maxrate(:,1:stop_crit_noisy,:),1),3),'b-');
p3 = plot(iters,mean(sum(convergence_perfect_maxsinr(:,end,:),1))*ones(size(iters)),'r:');
p4 = plot(iters,mean(sum(convergence_perfect_maxsinr(:,1:stop_crit_noisy,:),1),3),'r-');
p5 = plot(iters,mean(sum(convergence_prec_maxsinr(:,1:stop_crit_noisy,:),1),3),'r--');
p6 = plot(iters,mean(sum(convergence_prec_baseline_tdma,1),2)*ones(size(iters)),'c-');
p7 = plot(iters,mean(sum(convergence_prec_baseline_unc,1),2)*ones(size(iters)),'k-');
title('Prec Baselines');
legend([p1(1), p2(1), p3(1), p4(1), p5(1), p6(1), p7(1)], 'Perfect WMMSE (100 iters)', 'Perfect WMMSE', 'Perfect MaxSINR (100 iters)', 'Perfect MaxSINR', 'MaxSINR estim. CSI', 'TDMA estim. CSI', 'UNC estim. CSI', 'Location', 'SE');
xlabel('Iteration no.'); ylabel('Sum rate [bits/s/Hz]');

% RB-WMMSE
figure; hold on;
p1 = plot(iters,mean(sum(convergence_prec_MSr1BSr1_maxrate,1),3),'b-^');
p2 = plot(iters,mean(sum(convergence_prec_MSr1BSr0_maxrate,1),3),'r-o');
p3 = plot(iters,mean(sum(convergence_prec_MSr0BSr1_maxrate,1),3),'c-s');
p4 = plot(iters,mean(sum(convergence_prec_MSr0BSr0_maxrate,1),3),'m-v');
title('Prec RB-WMMSE');
legend([p1(1), p2(1), p3(1), p4(1)], 'MSr1BSr1', 'MSr1BSr0', 'MSr0BSr1', 'MSr0BSr0', 'Location','SE');
xlabel('Iteration no.'); ylabel('Sum rate [bits/s/Hz]');



% PREC GLOBAL WEIGHTS

% RB-WMMSE
figure; hold on;
p1 = plot(iters,mean(sum(convergence_precGLOB_MSr1BSr1_maxrate,1),3),'b-^');
p2 = plot(iters,mean(sum(convergence_precGLOB_MSr1BSr0_maxrate,1),3),'r-o');
p3 = plot(iters,mean(sum(convergence_precGLOB_MSr0BSr1_maxrate,1),3),'c-s');
p4 = plot(iters,mean(sum(convergence_precGLOB_MSr0BSr0_maxrate,1),3),'m-v');
title('PrecGLOB RB-WMMSE');
legend([p1(1), p2(1), p3(1), p4(1)], 'MSr1BSr1', 'MSr1BSr0', 'MSr0BSr1', 'MSr0BSr0', 'Location','SE');
xlabel('Iteration no.'); ylabel('Sum rate [bits/s/Hz]');