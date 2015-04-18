% ===============
% sumrateSIR_prec_IBC
% ===============

legends1{1} = 'WMMSE (perfect CSI)';									 
X1{1} = SIR_dBs; Y1{1} = mean(sum(sumrateSIR_baseline_maxrate,1),3);
legends1{2} = 'MaxSINR (perfect CSI)';
X1{2} = SIR_dBs; Y1{2} = mean(sum(sumrateSIR_baseline_maxsinr,1),3);
legends1{3} = 'RB-WMMSE';
X1{3} = SIR_dBs; Y1{3} = mean(sum(sumrateSIR_maxrate,1),3);
legends1{4} = 'MaxSINR';
X1{4} = SIR_dBs; Y1{4} = mean(sum(sumrateSIR_maxsinr,1),3);
legends1{5} = 'TDMA (intra-cell only)';
X1{5} = SIR_dBs; Y1{5} = mean(sum(sumrateSIR_baseline_tdma_intra,1),3);
legends1{6} = 'TDMA';
X1{6} = SIR_dBs; Y1{6} = mean(sum(sumrateSIR_baseline_tdma,1),3);
legends1{7} = 'Uncoord. transmission';
X1{7} = SIR_dBs; Y1{7} = mean(sum(sumrateSIR_baseline_unc ,1),3);

legend_location					 = 'SE';
legend_font_size         = 14;
plot_line_widths         = 2*ones(7,1);
plot_line_styles         = [ {'-'} ;
														 {'-'} ;
														 {'--'};
														 {':'} ;
														 {'-.'} ; 
														 {'-'} ; 
														 {'-'} ; ];
plot_line_colours        = [ rgb('Navy');
														 rgb('Crimson');
														 rgb('Navy');
														 rgb('Crimson');
														 rgb('DarkCyan');
														 rgb('DarkCyan');
														 rgb('Black'); ]; % (RGB)
plot_marker_sizes        = [6 6 6 6 6 6 6]; % points
plot_marker_types        = [ {'none'};
														 {'none'} ;
														 {'o'} ;
														 {'s'} ;
														 {'v'} ;
														 {'v'} ; 
														 {'^'} ; ];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 13.5], 'SIR [dB]', 'Average sum rate [bits/s/Hz]', [SIR_dBs(1) SIR_dBs(end)], [0 50], 0:5:50, 0:10:50);
rmsbrt_plot(X1,Y1,legends1,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
grid off;
export_fig('sumrateSIR_prec_IBC.pdf',f1);