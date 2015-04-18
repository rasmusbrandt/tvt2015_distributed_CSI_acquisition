% FULL

% Baselines
figure; hold on;
p1 = plot(SNRd_dBs,mean(sum(sumrateSNR_perfect_maxrate,1),3),'b-');
p2 = plot(SNRd_dBs,mean(sum(sumrateSNR_perfect_maxsinr,1),3),'r-');
p3 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_full_maxsinr,1),4)),'r--');
p5 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_full_baseline_tdma,1),4)),'c--');
p6 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_full_baseline_unc,1),4)),'k--');
title('Full baselines');
legend([p1(1), p2(1), p3(1), p5(1), p6(1)], 'Perfect WMMSE', 'Perfect MaxSINR', 'MaxSINR estim. CSI', 'TDMA estim. CSI', 'UNC estim. CSI', 'Location','NorthWest');
xlabel('Downlink SNR [dB]'); ylabel('Sum rate [bits/s/Hz]');

% RB-WMMSE and traditional robust
figure; hold on;
p0 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_full_tradrobust_maxrate,1),4)),'k-^');
p1 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_full_MSr1BSr1_maxrate,1),4)),'b-^');
p2 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_full_MSr1BSr0_maxrate,1),4)),'r-o');
p3 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_full_MSr0BSr1_maxrate,1),4)),'c-s');
p4 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_full_MSr0BSr0_maxrate,1),4)),'m-v');
title('Full RB-WMMSE');
legend([p0(1), p1(1), p2(1), p3(1), p4(1)], 'Traditional robust', 'MSr1BSr1', 'MSr1BSr0', 'MSr0BSr1', 'MSr0BSr0', 'Location','NorthWest');
xlabel('Downlink SNR [dB]'); ylabel('Sum rate [bits/s/Hz]');



% PREC

% Baselines
figure; hold on;
p1 = plot(SNRd_dBs,mean(sum(sumrateSNR_perfect_maxrate,1),3),'b-');
p2 = plot(SNRd_dBs,mean(sum(sumrateSNR_perfect_maxsinr,1),3),'r-');
p3 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_prec_maxsinr,1),4)),'r--');
p4 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_prec_baseline_tdma,1),4)),'c--');
p5 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_prec_baseline_unc,1),4)),'k--');
title('Prec baselines');
legend([p1(1), p2(1), p3(1), p4(1), p5(1)], 'Perfect WMMSE', 'Perfect MaxSINR', 'MaxSINR estim. CSI', 'TDMA estim. CSI', 'UNC estim. CSI', 'Location','NorthWest');
xlabel('Downlink SNR [dB]'); ylabel('Sum rate [bits/s/Hz]');

% RB-WMMSE
figure; hold on;
p1 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_prec_MSr1BSr1_maxrate,1),4)),'b-^');
p2 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_prec_MSr1BSr0_maxrate,1),4)),'r-o');
p3 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_prec_MSr0BSr1_maxrate,1),4)),'c-s');
p4 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_prec_MSr0BSr0_maxrate,1),4)),'m-v');
title('Prec RB-WMMSE');
legend([p1(1), p2(1), p3(1), p4(1)], 'MSr1BSr1', 'MSr1BSr0', 'MSr0BSr1', 'MSr0BSr0', 'Location','NorthWest');
xlabel('Downlink SNR [dB]'); ylabel('Sum rate [bits/s/Hz]');




% PREC GLOBAL WEIGHTS

% RB-WMMSE
figure; hold on;
p1 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_precGLOB_MSr1BSr1_maxrate,1),4)),'b-^');
p2 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_precGLOB_MSr1BSr0_maxrate,1),4)),'r-o');
p3 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_precGLOB_MSr0BSr1_maxrate,1),4)),'c-s');
p4 = plot(SNRd_dBs,squeeze(mean(sum(sumrateSNR_precGLOB_MSr0BSr0_maxrate,1),4)),'m-v');
title('PrecGLOB RB-WMMSE');
legend([p1(1), p2(1), p3(1), p4(1)], 'MSr1BSr1', 'MSr1BSr0', 'MSr0BSr1', 'MSr0BSr0', 'Location','NorthWest');
xlabel('Downlink SNR [dB]'); ylabel('Sum rate [bits/s/Hz]');