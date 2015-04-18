% ===============
% sumrateKc_prec_IBC
% ===============


legends1{1} = 'WMMSE (perfect CSI)';									 
X1{1} = Kc_scheds; Y1{1} = mean(mean(mean(sum(sumrateKc_baseline_maxrate,1),5),4),3);
legends1{2} = 'RB-WMMSE';
X1{2} = Kc_scheds; Y1{2} = mean(mean(mean(sum(sumrateKc_prec_MSr1BSr1_maxrate,1),5),4),3);
legends1{3} = 'MaxSINR (perfect CSI)';
X1{3} = Kc_scheds; Y1{3} = mean(mean(mean(sum(sumrateKc_baseline_maxsinr,1),5),4),3);
legends1{4} = 'MaxSINR';
X1{4} = Kc_scheds; Y1{4} = mean(mean(mean(sum(sumrateKc_prec_maxsinr,1),5),4),3);
legends1{5} = 'TDMA';
X1{5} = Kc_scheds; Y1{5} = mean(mean(mean(sum(sumrateKc_prec_baseline_tdma_inter,1),5),4),3);
legends1{6} = 'Uncoord. transmission';
X1{6} = Kc_scheds; Y1{6} = mean(mean(mean(sum(sumrateKc_prec_baseline_unc,1),5),4),3);
legends1{7} = 'TDMA (intra-cell only)';
X1{7} = Kc_scheds; Y1{7} = mean(mean(mean(sum(sumrateKc_prec_baseline_tdma_intra,1),5),4),3);
legends1{8} = 'WMMSE (naive)';
X1{8} = Kc_scheds; Y1{8} = mean(mean(mean(sum(sumrateKc_prec_MSr0BSr0_maxrate,1),5),4),3);


legend_location					 = 'NW';
legend_font_size         = 12;
plot_line_widths         = 2*ones(8,1);
plot_line_styles         = [ {'-'} ;
														 {'--'} ;
														 {'-'};
														 {':'} ; 
														 {'-'} ;
														 {'-'} ;
														 {'-.'} ;
														 {'-.'} ; ];
plot_line_colours        = [ rgb('Navy');
														 rgb('Navy');
														 rgb('Crimson');
														 rgb('Crimson');
														 rgb('DarkCyan');
														 rgb('Black');
														 rgb('DarkCyan');
														 rgb('Navy');]; % (RGB)
plot_marker_sizes        = 6*ones(8,1); % points
plot_marker_types        = [ {'none'};
														 {'o'} ;
														 {'none'} ;
														 {'s'} ; 
														 {'v'} ;
														 {'^'} ; 
														 {'v'} ;
														 {'o'} ;];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour2  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 13], 'Number of users selected for transmission per cell and subcarrier', 'Average sum rate [bits/s/Hz]', [Kc_scheds(1) Kc_scheds(end)], [0 60], 0:12, 0:10:60);
rmsbrt_plot(X1,Y1,legends1,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour2);
grid off;
export_fig('sumrateKcsched_largescale.pdf',f1);

