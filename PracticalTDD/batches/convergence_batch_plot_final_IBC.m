% ===============
% convergence_IBC
% ===============


iters = 1:stop_crit_noisy;

legends1{1} = 'WMMSE (perfect CSI)';
X1{1} = iters; Y1{1} = mean(sum(convergence_perfect_maxrate(:,1:stop_crit_noisy,:),1),3);
legends1{2} = 'RB-WMMSE (Sec. III-B)';
X1{2} = iters; Y1{2} = mean(sum(convergence_precGLOB_MSr1BSr0_maxrate,1),3);
legends1{3} = 'RB-WMMSE (Sec. III-A)';
X1{3} = iters; Y1{3} = mean(sum(convergence_prec_MSr1BSr1_maxrate,1),3);
legends1{4} = 'Naive WMMSE (Sec. III-A)';
X1{4} = iters; Y1{4} = mean(sum(convergence_prec_MSr0BSr0_maxrate,1),3);
legends1{5} = 'TDMA (MMSE estim.)';
X1{5} = iters; Y1{5} = mean(sum(convergence_full_baseline_tdma,1),2)*ones(size(iters));
legends1{6} = 'Uncoord. trans. (MMSE estim.)';
X1{6} = iters; Y1{6} = mean(sum(convergence_full_baseline_unc,1),2)*ones(size(iters));

legend_location					 = 'SE';
legend_font_size				 = 12;
plot_line_widths         = 2*ones(6,1);
plot_line_styles         = [ {'-'} ;
														 {'--'} ;
														 {':'} ; 
														 {'-'} ;
														 {'-'} ;
														 {'-'} ; ];
plot_line_colours        = [ rgb('Navy');
														 rgb('Navy');
														 rgb('Navy');
														 rgb('Magenta');
														 rgb('DarkCyan');
														 rgb('Black');]; % (RGB)
plot_marker_sizes        = [6 6 6 4 10 6]; % points
plot_marker_types        = [ {'none'} ;
														 {'none'} ;
														 {'none'} ; 
														 {'none'} ;
														 {'none'} ;
														 {'none'} ; ];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 9], 'Frame number', 'Average sum rate [bits/s/Hz]', [0 stop_crit_noisy], [0 32], 0:2:20, 0:5:30);
rmsbrt_plot(X1,Y1,legends1,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
grid off;

ax = gca;

set(ax,'XScale','log'); set(ax,'XTickMode','auto');

export_fig('convergence_IBC.pdf',f1);