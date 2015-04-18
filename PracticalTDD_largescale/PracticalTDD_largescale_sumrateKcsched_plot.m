figure; hold on;

plot(Kc_scheds, sum(mean(mean(mean(sumrateKc_maxrate,5),4),3),1), 'b--');
plot(Kc_scheds, sum(mean(mean(mean(sumrateKc_maxsinr,5),4),3),1), 'r--');
plot(Kc_scheds, sum(mean(mean(mean(sumrateKc_baseline_maxrate,5),4),3),1), 'b-');
plot(Kc_scheds, sum(mean(mean(mean(sumrateKc_baseline_maxsinr,5),4),3),1), 'r-');
plot(Kc_scheds, sum(mean(mean(mean(sumrateKc_baseline_tdma_inter,5),4),3),1), 'c-');
plot(Kc_scheds, sum(mean(mean(mean(sumrateKc_baseline_tdma_intra,5),4),3),1), 'c-.');
plot(Kc_scheds, sum(mean(mean(mean(sumrateKc_baseline_unc,5),4),3),1),'k-');

legend('MaxRate','MaxSINR');
xlabel(['Scheduled users per cell (out of ' num2str(Kc) ')']); ylabel('Sum rate [bpcu]');
title(sprintf('Noisy. Nsim = %d, Kt = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Mt,Mr,Nd,MS_robustification));
