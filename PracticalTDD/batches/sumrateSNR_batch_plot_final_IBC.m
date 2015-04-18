SNRu_inds = 1:2;


% ===============
% sumrateSNR_prec_IBC
% ===============


legends1{1} = 'WMMSE (perfect CSI)';									 
X1{1} = SNRd_dBs; Y1{1} = mean(sum(sumrateSNR_perfect_maxrate,1),3);
legends1{2} = 'RB-WMMSE';
X1{2} = SNRd_dBs; Y1{2} = squeeze(mean(sum(sumrateSNR_prec_MSr1BSr1_maxrate(:,:,SNRu_inds,:),1),4));
legends1{3} = 'MaxSINR';
X1{3} = SNRd_dBs; Y1{3} = squeeze(mean(sum(sumrateSNR_prec_maxsinr(:,:,SNRu_inds,:),1),4));
legends1{4} = 'TDMA';
X1{4} = SNRd_dBs; Y1{4} = squeeze(mean(sum(sumrateSNR_prec_baseline_tdma(:,:,end,:),1),4));
legends1{5} = 'Uncoord. transmission';
X1{5} = SNRd_dBs; Y1{5} = squeeze(mean(sum(sumrateSNR_prec_baseline_unc(:,:,end,:),1),4));

legend_location					 = 'NW';
legend_font_size         = 16;
plot_line_widths         = 2*ones(7,1);
plot_line_styles         = [ {'-'} ;
														 {'--'};
														 {':'} ;
														 {'-'} ; 
														 {'-'} ; ];
plot_line_colours        = [ rgb('Navy');
														 rgb('Navy');
														 rgb('Crimson');
														 rgb('DarkCyan');
														 rgb('Black'); ]; % (RGB)
plot_marker_sizes        = [6 6 6 6 6]; % points
plot_marker_types        = [ {'none'};
														 {'o'} ;
														 {'s'} ;
														 {'v'} ; 
														 {'^'} ; ];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 13], 'Downlink SNR [dB]', 'Average sum rate [bits/s/Hz]', [SNRd_dBs(1) SNRd_dBs(end)], [0 40], 0:5:30, 0:5:40);
rmsbrt_plot(X1,Y1,legends1,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
grid off;
export_fig('sumrateSNR_prec_IBC.pdf',f1);




% ===============
% sumrateSNR_prec_IBC
% ===============


legends2{1} = 'WMMSE (perfect CSI)';									 
X2{1} = SNRd_dBs; Y2{1} = mean(sum(sumrateSNR_perfect_maxrate,1),3);
legends2{2} = 'Lower bound opt. WMMSE';
X2{2} = SNRd_dBs; Y2{2} = squeeze(mean(sum(sumrateSNR_full_tradrobust_maxrate(:,:,SNRu_inds,:),1),4));
legends2{3} = 'RB-WMMSE (\rho = 1)';
X2{3} = SNRd_dBs; Y2{3} = squeeze(mean(sum(sumrateSNR_full_MSr1BSr0_maxrate(:,:,SNRu_inds,:),1),4));
legends2{4} = 'MaxSINR';
X2{4} = SNRd_dBs; Y2{4} = squeeze(mean(sum(sumrateSNR_full_maxsinr(:,:,SNRu_inds,:),1),4));
legends2{5} = 'TDMA';
X2{5} = SNRd_dBs; Y2{5} = squeeze(mean(sum(sumrateSNR_full_baseline_tdma(:,:,end,:),1),4));
legends2{6} = 'Uncoord. transmission';
X2{6} = SNRd_dBs; Y2{6} = squeeze(mean(sum(sumrateSNR_full_baseline_unc(:,:,end,:),1),4));

legend_location					 = 'NW';
legend_font_size         = 15;
plot_line_widths         = 2*ones(7,1);
plot_line_styles         = [ {'-'} ;
	                           {':'};
														 {'--'};
														 {':'} ;
														 {'-'} ; 
														 {'-'} ; ];
plot_line_colours        = [ rgb('Navy');
														 rgb('SteelBlue');
														 rgb('Navy');
														 rgb('Crimson');
														 rgb('DarkCyan');
														 rgb('Black'); ]; % (RGB)
plot_marker_sizes        = [6 10 6 6 6 6]; % points
plot_marker_types        = [ {'none'};
														 {'x'} ;
														 {'o'} ;
														 {'s'} ;
														 {'v'} ; 
														 {'^'} ; ];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 13], 'Downlink SNR [dB]', 'Average sum rate [bits/s/Hz]', [SNRd_dBs(1) SNRd_dBs(end)], [0 40], 0:5:30, 0:5:40);
rmsbrt_plot(X2,Y2,legends2,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
grid off;
export_fig('sumrateSNR_full_IBC.pdf',f1);