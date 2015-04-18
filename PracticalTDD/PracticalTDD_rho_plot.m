figure; hold on;
plot(10*log10(rhos) + SNRd_dB,squeeze(mean(sum(rho_maxrate,1),4)));
xlabel('Scaled power constraint [dB]'); ylabel('Average sum rate [bits/s/Hz]');

for n = 1:length(SNRu_dBs)
	tmp = squeeze(mean(sum(rho_maxrate,1),4));
	[ymax,ind] = max(tmp(:,n));

	[~,indmin] = min((10*log10(rhos) + SNRd_dB - SNRu_dBs(n)).^2);
	
	plot(10*log10(rhos(indmin)) + SNRd_dB, tmp(indmin,n), 'ko');
end