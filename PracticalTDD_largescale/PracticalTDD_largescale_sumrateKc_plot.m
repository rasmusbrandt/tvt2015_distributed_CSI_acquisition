figure; hold on;

plot(Kcs, sum(mean(mean(mean(sumrateKc_maxrate,5),4),3),1), 'b--');
plot(Kcs, sum(mean(mean(mean(sumrateKc_maxsinr,5),4),3),1), 'r--');
plot(Kcs, sum(mean(mean(mean(sumrateKc_baseline_maxrate,5),4),3),1), 'b-');
plot(Kcs, sum(mean(mean(mean(sumrateKc_baseline_maxsinr,5),4),3),1), 'r-');
plot(Kcs, sum(mean(mean(mean(sumrateKc_baseline_tdma_inter,5),4),3),1), 'c-');
plot(Kcs, sum(mean(mean(mean(sumrateKc_baseline_tdma_intra,5),4),3),1), 'c-.');
plot(Kcs, sum(mean(mean(mean(sumrateKc_baseline_unc,5),4),3),1),'k-');

legend('MaxRate','MaxSINR');
xlabel('Users Kc'); ylabel('Sum rate [bpcu]');
title(sprintf('Noisy. Nsim = %d, Kt = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Mt,Mr,Nd,MS_robustification));

% Can't use the standard CLT here, since the samples are correlated.
cis = zeros(length(Kcs),1);
for ii_Kc = 1:length(Kcs)
	maxrate_std = std(vec(sum(sumrateKc_maxrate(:,ii_Kc,:,:,:),1)));
	cis(ii_Kc) = 1.96*maxrate_std/sqrt(Nnetworks*Nshadow*Nsim);
end
figure;
errorbar(Kcs, sum(mean(mean(mean(sumrateKc_maxrate,5),4),3),1), cis);

% figure; hold on;
% plot(Kcs, sum(mean(mean(mean(sumrateKc_baseline_unc,5),4),3),1), 'k');
% plot(Kcs, sum(mean(mean(mean(sumrateKc_baseline_tdma,5),4),3),1), 'c');
% legend('Uncoordinated','TDMA');
% xlabel('Users Kc'); ylabel('Sum rate [bpcu]');
% title(sprintf('Noisy. Nsim = %d, Kt = %d, Mt = %d, Mr = %d, Nd = %d, MS\\_r = %d',Nsim,Kt,Mt,Mr,Nd,MS_robustification));

figure; hold on;
for ii_Kc = 1:length(Kcs)
	active_user_inds = kron(ones(Kt,1),[ones(Kcs(ii_Kc),1);zeros(max(Kcs)-Kcs(ii_Kc),1)]);
	[Fmaxrate,Xmaxrate] = ecdf(vec(sumrateKc_maxrate(active_user_inds == 1,ii_Kc,:,:,:)));
	[Fmaxsinr,Xmaxsinr] = ecdf(vec(sumrateKc_maxsinr(active_user_inds == 1,ii_Kc,:,:,:)));
	[Func,Xunc] = ecdf(vec(sumrateKc_baseline_unc(:,ii_Kc,:,:,:)));
	plot(Xmaxrate,Fmaxrate,'b');
	plot(Xmaxsinr,Fmaxsinr,'r');
	plot(Xunc,Func,'k');
end
xlabel('User rates [bpcu]'); ylabel('CDF');
