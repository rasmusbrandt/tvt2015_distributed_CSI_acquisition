% Fixed SNRd
figure; hold on;
SNRd_ind = length(SNRd_dBs_tr1);
for ii_SNRu = 1:length(SNRu_dBs_tr1)
	plot(quantizer_bits(end-1:end), sum(mean(sumrateQres_rates_perfect_SNRd_dB40(:,SNRd_ind,ii_SNRu,:),4),1)*ones(2,1), 'b-d');
	
	plot(quantizer_bits, squeeze(sum(mean(sumrateQres_rates_quantized_SNRd_dB40(:,SNRd_ind,ii_SNRu,:,:),5),1)), 'b--');

	legend('Perfect feedback', 'Quantized feedback', 'Location', 'NorthWest');
	
	xlabel('Number of quantizer bits');
	ylabel('Sum rate [bits/s/Hz]');
	title(['SNRd = ' num2str(SNRd_dBs_tr1(SNRd_ind)) ' dB, SNRu = ' num2str(SNRu_dBs_tr1) ' dB']);
end

% Fixed SNRu
figure; hold on;
SNRu_ind = length(SNRu_dBs_tr2);
for ii_SNRd = 1:length(SNRd_dBs_tr2)
	plot(quantizer_bits(end-1:end), sum(mean(sumrateQres_rates_perfect_SNRu_dB40(:,ii_SNRd,SNRu_ind,:),4),1)*ones(2,1), 'b-d');

	plot(quantizer_bits, squeeze(sum(mean(sumrateQres_rates_quantized_SNRu_dB40(:,ii_SNRd,SNRu_ind,:,:),5),1)), 'b--');
	
	legend('Perfect feedback', 'Quantized feedback', 'Location', 'NorthWest');
	
	xlabel('Number of quantizer bits');
	ylabel('Sum rate [bits/s/Hz]');
	title(['SNRd = ' num2str(SNRd_dBs_tr2) ' dB, SNRu = ' num2str(SNRu_dBs_tr2(SNRu_ind)) ' dB']);
end