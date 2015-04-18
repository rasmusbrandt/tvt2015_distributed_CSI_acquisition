SNRu_ind = 2;
disp(['SNRu = ' num2str(SNRu_dBs(SNRu_ind)) ' dB']);

legends{1} = 'Perfect CSI';
X{1} = SNRd_dBs; Y{1} = mean(sum(sumrateSNR_perfect_maxrate,1),3);
legends{2} = 'Sec. III-C';
X{2} = SNRd_dBs; Y{2} = squeeze(mean(sum(sumrateSNR_full_MSr0BSr0_maxrate(:,:,SNRu_ind,:),1),4));
legends{3} = 'Sec. III-B';
X{3} = SNRd_dBs; Y{3} = squeeze(mean(sum(sumrateSNR_precGLOB_MSr0BSr0_maxrate(:,:,SNRu_ind,:),1),4));
legends{4} = 'Sec. III-A';
X{4} = SNRd_dBs; Y{4} = squeeze(mean(sum(sumrateSNR_prec_MSr0BSr0_maxrate(:,:,SNRu_ind,:),1),4));

legend_location					 = 'NW';
legend_font_size         = 16;
plot_line_widths         = 2*ones(4,1);
plot_line_styles         = [ {'-'} ;
														 {'-'} ;
														 {'--'};
														 {':'} ; ];
plot_line_colours        = [ rgb('Crimson');
														 rgb('Navy');
														 rgb('Navy');
														 rgb('Navy'); ]; % (RGB)
plot_marker_sizes        = 6*ones(4,1); % points
plot_marker_types        = [ {'o'} ;
														 {'none'} ;
														 {'none'} ;
														 {'none'} ; ];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 9], 'Downlink SNR [dB]', 'Average sum rate [bits/s/Hz]', [SNRd_dBs(1) SNRd_dBs(end)], [0 40], 0:5:30, 0:5:40);
rmsbrt_plot(X,Y,legends,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
grid off;
export_fig('sumrateSNR_naive.pdf',f1);