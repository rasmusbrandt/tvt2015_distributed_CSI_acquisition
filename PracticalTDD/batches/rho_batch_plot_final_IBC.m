for n = 1:length(SNRu_dBs)
	X2{n} = 10*log10(rhos) + SNRd_dB;
	Y2{n} = squeeze(mean(sum(rho_maxrate(:,:,n,:),1),4));
	legends2{n} = '';
end

legend_location					 = 'SE';
legend_font_size         = 16;
plot_line_widths         = 2*ones(length(SNRu_dBs),1);
plot_line_styles         = [ {'-'} ;
														 {'-'} ;
														 {'-'} ;
														 {'-'} ; 
														 {'-'} ;
														 {'-'} ;
														 {'-'} ;];
plot_line_colours        = [ rgb('Crimson');
														 rgb('DarkRed');
														 rgb('RoyalBlue');
														 rgb('Navy');
														 rgb('LimeGreen');
														 rgb('DarkGreen');
														 rgb('Gray');
	                            ]; % (RGB)
plot_marker_sizes        = 6*ones(length(SNRu_dBs),1); % points
plot_marker_types        = [ {'none'};
														 {'none'} ;
														 {'none'} ;
														 {'none'} ; 
														 {'none'} ;
														 {'none'} ;
														 {'none'} ;];
plot_marker_face_colour  = [ rgb('Crimson');
														 rgb('DarkRed');
														 rgb('RoyalBlue');
														 rgb('Navy');
														 rgb('LimeGreen');
														 rgb('DarkGreen');
														 rgb('Gray'); 
														  ]; % (RGB)
plot_marker_edge_colour  = plot_marker_face_colour;

xa = 10*log10(rhos) + SNRd_dB;
f2 = rmsbrt_figure([20 9], 'Scaled Sum Power Constraint \rho P_t [dB]', 'Average sum rate [bits/s/Hz]', [10*log10(rhos(1)) + SNRd_dB, 10*log10(rhos(end)) + SNRd_dB], [0 40], -10:10:30, 0:10:40);
rmsbrt_plot(X2,Y2,legends2,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour);
grid off; legend off;


for n = 1:length(SNRu_dBs)
	[~,ind] = min((10*log10(rhos) + SNRd_dB - SNRu_dBs(n)).^2);
	ym = Y2{n};
	plot(10*log10(rhos(ind)) + SNRd_dB, ym(ind), 'k', ...
	'Marker',          'o',         ...
	'MarkerSize',      plot_marker_sizes(n),         ...
	'MarkerFaceColor', plot_marker_face_colour(n,:), ...
  'MarkerEdgeColor', plot_marker_edge_colour(n,:));
end
export_fig('rho_IBC.pdf',f2);