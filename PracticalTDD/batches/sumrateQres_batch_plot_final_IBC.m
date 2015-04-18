% ===============
% sumrateQres_fixed_SNRu
% ===============

SNRu_ind = length(SNRu_dBs_tr2);

legends1{1} = 'Perfect feedback';									 
X1{1} = quantizer_bits(end-1:end); Y1{1} = diag(mean(sum(sumrateQres_rates_perfect_SNRu_dB40(:,:,SNRu_ind,:),1),4))*ones(length(SNRd_dBs_tr2),2);
legends1{2} = 'Quantized feedback';
X1{2} = quantizer_bits; Y1{2} = squeeze(mean(sum(sumrateQres_rates_quantized_SNRu_dB40(:,:,SNRu_ind,:,:),1),5));


legend_location					 = 'NW';
legend_font_size         = 16;
plot_line_widths         = 2*ones(2,1);
plot_line_styles         = [ {'-'} ;
														 {'--'}; ];
plot_line_colours        = [ rgb('Navy');
														 rgb('Navy'); ]; % (RGB)
plot_marker_sizes        = [6 6]; % points
plot_marker_types        = [ {'s'};
														 {'o'} ; ];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 9], 'Number of quantization bits', 'Average sum rate [bits/s/Hz]', [quantizer_bits(1) quantizer_bits(end)], [0 40], 1:8, 0:10:40);
rmsbrt_plot(X1,Y1,legends1,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
grid off;
export_fig('sumrateQres_fixed_SNRu.pdf',f1);