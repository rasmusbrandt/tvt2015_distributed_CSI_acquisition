figure;
plot(SNRd_dBs, sum(mean(sumrateSNR_baseline_maxrate,3),1)  , 'b-', ...
	   SNRd_dBs, sum(mean(sumrateSNR_baseline_maxsinr,3),1)  , 'r-', ...
	   SNRd_dBs, sum(mean(sumrateSNR_baseline_tdma(:,:,end,:),4),1), 'c-', ...
	   SNRd_dBs, sum(mean(sumrateSNR_baseline_unc(:,:,end,:) ,4),1), 'k-'  ...
	  );
legend('MaxRate perfect', 'MaxSINR perfect', 'TDMA WF', 'Unc WF');
xlabel('SNRd [dB]'); ylabel('Sum rate [bpcu]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Kc,Mt,Mr,Nd,MS_robustification));

figure; hold on;
for ii_SNRu = 1:length(SNRu_dBs)
	plot(SNRd_dBs, sum(mean(sumrateSNR_baseline_tdma(:,:,ii_SNRu,:),4),1), 'b--');
end
legend('TDMA noisy');
xlabel('SNRd [dB]'); ylabel('Sum rate [bpcu]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Kc,Mt,Mr,Nd,MS_robustification));


figure; hold on;
plot(SNRd_dBs, sum(mean(sumrateSNR_baseline_maxrate,3),1), 'b-');
for ii_SNRu = 1:length(SNRu_dBs)
	plot(SNRd_dBs, sum(mean(sumrateSNR_maxrate(:,:,ii_SNRu,:),4),1), 'b--');
end
legend('MaxRate perfect','MaxRate noisy');
xlabel('SNRd [dB]'); ylabel('Sum rate [bpcu]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Kc,Mt,Mr,Nd,MS_robustification));


figure; hold on;
plot(SNRd_dBs, sum(mean(sumrateSNR_baseline_maxsinr,3),1), 'r-');
for ii_SNRu = 1:length(SNRu_dBs)
	plot(SNRd_dBs, sum(mean(sumrateSNR_maxsinr(:,:,ii_SNRu,:),4),1), 'r--');
end
legend('MaxSINR perfect','MaxSINR noisy');
xlabel('SNRd [dB]'); ylabel('Sum rate [bpcu]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Kc,Mt,Mr,Nd,MS_robustification));


figure; hold on;
plot(SNRd_dBs, sum(mean(sumrateSNR_baseline_maxrate,3),1), 'b-');
plot(SNRd_dBs, sum(mean(sumrateSNR_baseline_maxsinr,3),1), 'r-');
for ii_SNRu = 1:length(SNRu_dBs)
	plot(SNRd_dBs, sum(mean(sumrateSNR_maxrate(:,:,ii_SNRu,:),4),1), 'b');
	plot(SNRd_dBs, sum(mean(sumrateSNR_maxsinr(:,:,ii_SNRu,:),4),1), 'r');
end
legend('MaxRate','MaxSINR');
xlabel('SNRd [dB]'); ylabel('Sum rate [bpcu]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Kc,Mt,Mr,Nd,MS_robustification));
