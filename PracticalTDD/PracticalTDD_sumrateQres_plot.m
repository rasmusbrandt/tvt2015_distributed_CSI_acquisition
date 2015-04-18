% SNRd == SNRu
if(all(SNRd_dBs == SNRu_dBs))
	figure; hold on;
	for ii_SNR = 1:length(SNRd_dBs)
		plot(quantizer_bits, squeeze(sum(mean(sumrateQres_rates_quantized(:,ii_SNR,ii_SNR,:,:),5),1)), 'b--');
		
		plot(quantizer_bits(end-1:end), sum(mean(sumrateQres_rates_perfect(:,ii_SNR,ii_SNR,:),4),1)*ones(2,1), 'b-d');
		
		legend('Quantized feedback', 'Perfect feedback', 'Location', 'NorthWest');
	end
	xlabel('Number of quantizer bits');
	ylabel('Sum rate [bits/s/Hz]');
	title(['SNRd = SNRu = ' num2str(SNRd_dBs) ' dB']);
end

% Fixed SNRd
figure; hold on;
SNRd_ind = length(SNRd_dBs);
for ii_SNRu = 1:length(SNRu_dBs)
	plot(quantizer_bits, squeeze(sum(mean(sumrateQres_rates_quantized(:,SNRd_ind,ii_SNRu,:,:),5),1)), 'b--');

	plot(quantizer_bits(end-1:end), sum(mean(sumrateQres_rates_perfect(:,SNRd_ind,ii_SNRu,:),4),1)*ones(2,1), 'b-d');

	legend('Quantized feedback', 'Perfect feedback', 'Location', 'NorthWest');
	
	xlabel('Number of quantizer bits');
	ylabel('Sum rate [bits/s/Hz]');
	title(['SNRd = ' num2str(SNRd_dBs(SNRd_ind)) ' dB, SNRu = ' num2str(SNRu_dBs) ' dB']);
end

% Fixed SNRu
figure; hold on;
SNRu_ind = length(SNRu_dBs);
for ii_SNRd = 1:length(SNRd_dBs)
	plot(quantizer_bits, squeeze(sum(mean(sumrateQres_rates_quantized(:,ii_SNRd,SNRu_ind,:,:),5),1)), 'b--');

	plot(quantizer_bits(end-1:end), sum(mean(sumrateQres_rates_perfect(:,ii_SNRd,SNRu_ind,:),4),1)*ones(2,1), 'b-d');

	legend('Quantized feedback', 'Perfect feedback', 'Location', 'NorthWest');
	
	xlabel('Number of quantizer bits');
	ylabel('Sum rate [bits/s/Hz]');
	title(['SNRd = ' num2str(SNRd_dBs) ' dB, SNRu = ' num2str(SNRu_dBs(SNRu_ind)) ' dB']);
end

% Surface
figure;
[X,Y] = meshgrid(quantizer_bits,SNRd_dBs);
surf(X,Y,squeeze(sum(mean(sumrateQres_rates_quantized(:,:,end,:,:),5),1)));
