% ===============
% tr_UWUh_convergence
% ===============

iters = 1:stop_crit_perfect;
for l = 1:Kt
	for k = 1:Kc
		ind = (l-1)*Kc + k;

		X2{ind} = iters; Y2{ind} = 10*log10(convergence_maxrate_UWsqrt_perfect(ind,iters));
		legends2{ind} = ['UE ' num2str(l) '_' num2str(k)];
	end
end

legend_location					 = 'SE';
legend_font_size         = 16;
plot_line_widths         = 2*ones(Kr,1);
plot_line_styles         = [ {'-'} ;
														 {':'} ;
														 {'-'} ;
														 {':'} ; 
														 {'-'} ;
														 {':'} ; ];
plot_line_colours        = [ rgb('Crimson');
														 rgb('DarkRed');
														 rgb('RoyalBlue');
														 rgb('Navy');
														 rgb('LimeGreen');
														 rgb('DarkGreen'); ]; % (RGB)
plot_marker_sizes        = 6*ones(Kr,1); % points
plot_marker_types        = [ {'o'};
														 {'o'} ;
														 {'s'} ;
														 {'s'} ; 
														 {'v'} ;
														 {'v'} ; ];
plot_marker_face_colour  = [ rgb('Crimson');
														 rgb('DarkRed');
														 rgb('RoyalBlue');
														 rgb('Navy');
														 rgb('LimeGreen');
														 rgb('DarkGreen'); ]; % (RGB)
plot_marker_edge_colour  = plot_marker_face_colour;


f2 = rmsbrt_figure([20 9], 'Subframe number', '||A_{ik} W_{ik}^{1/2}||_F^2 [dB]', [1 iters(end)], [-40 0], iters, -40:10:0);
rmsbrt_plot(X2,Y2,legends2,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
grid off;
export_fig('AWsqrt_IBC.pdf',f2);