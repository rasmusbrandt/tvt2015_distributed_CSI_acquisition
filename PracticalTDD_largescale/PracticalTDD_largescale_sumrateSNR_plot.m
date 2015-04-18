figure;
plot(Pt_dBms, sum(mean(mean(mean(sumrateSNR_baseline_maxrate,5),4),3),1)  , 'b-', ...
	   Pt_dBms, sum(mean(mean(mean(sumrateSNR_baseline_maxsinr,5),4),3),1)  , 'r-', ...
	   Pt_dBms, sum(mean(mean(mean(sumrateSNR_baseline_tdma(:,:,end,:,:,:),6),5),4),1), 'c-', ...
	   Pt_dBms, sum(mean(mean(mean(sumrateSNR_baseline_unc(:,:,end,:,:,:) ,6),5),4),1), 'k-'  ...
	  );
legend('MaxRate perfect', 'MaxSINR perfect', 'TDMA WF', 'Unc WF');
xlabel('SNRd [dB]'); ylabel('Sum rate [bpcu]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Kc,Mt,Mr,Nd,MS_robustification));

figure; hold on;
for ii_SNRu = 1:length(Pr_dBms)
	plot(Pt_dBms, sum(mean(mean(mean(sumrateSNR_baseline_tdma(:,:,ii_SNRu,:,:,:),6),5),4),1), 'b--');
end
legend('TDMA noisy');
xlabel('SNRd [dB]'); ylabel('Sum rate [bpcu]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Kc,Mt,Mr,Nd,MS_robustification));


figure; hold on;
plot(Pt_dBms, sum(mean(mean(mean(sumrateSNR_baseline_maxrate,5),4),3),1), 'b-');
for ii_SNRu = 1:length(Pr_dBms)
	plot(Pt_dBms, sum(mean(mean(mean(sumrateSNR_maxrate(:,:,ii_SNRu,:,:,:),6),5),4),1), 'b--');
end
legend('MaxRate perfect','MaxRate noisy');
xlabel('SNRd [dB]'); ylabel('Sum rate [bpcu]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Kc,Mt,Mr,Nd,MS_robustification));


figure; hold on;
plot(Pt_dBms, sum(mean(mean(mean(sumrateSNR_baseline_maxsinr,5),4),3),1), 'r-');
for ii_SNRu = 1:length(Pr_dBms)
	plot(Pt_dBms, sum(mean(mean(mean(sumrateSNR_maxsinr(:,:,ii_SNRu,:,:,:),6),5),4),1), 'r--');
end
legend('MaxSINR perfect','MaxSINR noisy');
xlabel('SNRd [dB]'); ylabel('Sum rate [bpcu]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Kc,Mt,Mr,Nd,MS_robustification));


figure; hold on;
plot(Pt_dBms, sum(mean(mean(mean(sumrateSNR_baseline_maxrate,5),4),3),1), 'b-');
plot(Pt_dBms, sum(mean(mean(mean(sumrateSNR_baseline_maxsinr,5),4),3),1), 'r-');
for ii_SNRu = 1:length(Pr_dBms)
	plot(Pt_dBms, sum(mean(mean(mean(sumrateSNR_maxrate(:,:,ii_SNRu,:,:,:),6),5),4),1), 'b');
	plot(Pt_dBms, sum(mean(mean(mean(sumrateSNR_maxsinr(:,:,ii_SNRu,:,:,:),6),5),4),1), 'r');
end
legend('MaxRate','MaxSINR');
xlabel('SNRd [dB]'); ylabel('Sum rate [bpcu]');
title(sprintf('Nsim = %d, Kt = %d, Kc = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Kc,Mt,Mr,Nd,MS_robustification));
