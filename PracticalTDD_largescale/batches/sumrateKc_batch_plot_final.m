% ===============
% sumrateKc_prec_IBC
% ===============


legends1{1} = 'WMMSE (perfect CSI)';									 
X1{1} = Kcs; Y1{1} = mean(mean(mean(sum(sumrateKc_baseline_maxrate,1),5),4),3);
legends1{2} = 'MaxSINR (perfect CSI)';
X1{2} = Kcs; Y1{2} = mean(mean(mean(sum(sumrateKc_baseline_maxsinr,1),5),4),3);
legends1{3} = 'RB-WMMSE';
X1{3} = Kcs; Y1{3} = mean(mean(mean(sum(sumrateKc_prec_MSr1BSr1_maxrate,1),5),4),3);
legends1{4} = 'Uncoord. transmission';
X1{4} = Kcs; Y1{4} = mean(mean(mean(sum(sumrateKc_prec_baseline_unc,1),5),4),3);
legends1{5} = 'MaxSINR';
X1{5} = Kcs; Y1{5} = mean(mean(mean(sum(sumrateKc_prec_maxsinr,1),5),4),3);
legends1{6} = 'TDMA';
X1{6} = Kcs; Y1{6} = mean(mean(mean(sum(sumrateKc_prec_baseline_tdma_inter,1),5),4),3);
legends1{7} = 'WMMSE (naive)';
X1{7} = Kcs; Y1{7} = mean(mean(mean(sum(sumrateKc_prec_MSr0BSr0_maxrate,1),5),4),3);


legend_location					 = 'NW';
legend_font_size         = 12;
plot_line_widths         = 2*ones(7,1);
plot_line_styles         = [ {'-'} ;
														 {'-'} ;
														 {'--'};
														 {'-'} ; 
														 {':'} ;
														 {'-'} ; 
														 {'-.'} ; ];
plot_line_colours        = [ rgb('Navy');
														 rgb('Crimson');
														 rgb('Navy');
														 rgb('Black');
														 rgb('Crimson');
														 rgb('DarkCyan');
														 rgb('Navy'); ]; % (RGB)
plot_marker_sizes        = 6*ones(7,1); % points
plot_marker_types        = [ {'none'};
														 {'none'} ;
														 {'o'} ;
														 {'^'} ; 
														 {'s'} ;
														 {'v'} ; 
														 {'o'} ; ];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour2  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 13], 'Total number of users per cell and subcarrier K_c', 'Average sum rate [bits/s/Hz]', [Kcs(1) Kcs(end)], [0 50], 0:12, 0:10:50);
rmsbrt_plot(X1,Y1,legends1,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour2);
grid off;
export_fig('sumrateKc_prec_largescale.pdf',f1);

