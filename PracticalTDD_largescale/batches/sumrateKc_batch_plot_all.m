% ===============
% sumrateKc_prec_IBC
% ===============


legends1{1} = 'WMMSE (perfect CSI)';									 
X1{1} = Kcs; Y1{1} = mean(mean(mean(sum(sumrateKc_baseline_maxrate,1),5),4),3);
legends1{2} = 'RB-WMMSE';
X1{2} = Kcs; Y1{2} = mean(mean(mean(sum(sumrateKc_prec_MSr1BSr1_maxrate,1),5),4),3);
legends1{3} = 'MaxSINR (perfect CSI)';
X1{3} = Kcs; Y1{3} = mean(mean(mean(sum(sumrateKc_baseline_maxsinr,1),5),4),3);
legends1{4} = 'MaxSINR';
X1{4} = Kcs; Y1{4} = mean(mean(mean(sum(sumrateKc_prec_maxsinr,1),5),4),3);
legends1{5} = 'WMMSE (naive)';
X1{5} = Kcs; Y1{5} = mean(mean(mean(sum(sumrateKc_prec_MSr0BSr0_maxrate,1),5),4),3);

legend_location					 = 'SE';
legend_font_size         = 16;
plot_line_widths         = 2*ones(7,1);
plot_line_styles         = [ {'-'} ;
														 {'--'};
														 {'-'} ;
														 {':'} ; 
														 {'-.'} ; ];
plot_line_colours        = [ rgb('Navy');
														 rgb('Navy');
														 rgb('Crimson');
														 rgb('Crimson');
														 rgb('Navy'); ]; % (RGB)
plot_marker_sizes        = [6 6 6 6 6]; % points
plot_marker_types        = [ {'none'};
														 {'o'} ;
														 {'s'} ;
														 {'s'} ; 
														 {'o'} ; ];
plot_marker_face_colour  = plot_line_colours;
plot_marker_edge_colour2  = plot_marker_face_colour;

f1 = rmsbrt_figure([20 13], 'Number of users per cell K_c', 'Average sum rate [bits/s/Hz]', [Kcs(1) Kcs(end)], [0 80], 0:12, 0:10:80);
rmsbrt_plot(X1,Y1,legends1,legend_location,legend_font_size,plot_line_widths,plot_line_styles,plot_line_colours,plot_marker_sizes,plot_marker_types,plot_marker_face_colour,plot_marker_edge_colour2);
grid off;



% CDF
f2 = rmsbrt_figure([20 13], 'User rates [bits/s/Hz]', 'Estimated cumulative distribution function', [0 14], [0 100], 0:2:14, 0:10:100);
X2 = cell(2*length(Kcs),1); F2 = cell(2*length(Kcs),1);

legends2 = cell(2*length(Kcs),1);
plot_line_styles2 = cell(2*length(Kcs),1);
plot_line_colours2 = zeros(2*length(Kcs),3);
plot_marker_types2 = cell(2*length(Kcs),1);

for ii_Kc = 1:length(Kcs)
	active_user_inds = kron(ones(Kt,1),[ones(Kcs(ii_Kc),1);zeros(max(Kcs)-Kcs(ii_Kc),1)]);
	[F2{2*(ii_Kc-1) + 1},X2{2*(ii_Kc-1) + 1}] = ecdf(vec(sumrateKc_prec_MSr1BSr1_maxrate(active_user_inds == 1,ii_Kc,:,:,:)));
	F2{2*(ii_Kc-1) + 1} = 100*F2{2*(ii_Kc-1) + 1};
	[F2{2*(ii_Kc-1) + 2},X2{2*(ii_Kc-1) + 2}] = ecdf(vec(sumrateKc_prec_maxsinr(active_user_inds == 1,ii_Kc,:,:,:)));
	F2{2*(ii_Kc-1) + 2} = 100*F2{2*(ii_Kc-1) + 2};
	
	legends2{2*(ii_Kc-1) + 1} = '';
	legends2{2*(ii_Kc-1) + 2} = '';
	
	plot_line_styles2{2*(ii_Kc-1) + 1} = '--';
	plot_line_styles2{2*(ii_Kc-1) + 2} = ':';
	
	plot_line_colours2(2*(ii_Kc-1) + 1,:) = rgb('Navy');
	plot_line_colours2(2*(ii_Kc-1) + 2,:) = rgb('Crimson');
	
	plot_marker_types2{2*(ii_Kc-1) + 1} = 'none';
	plot_marker_types2{2*(ii_Kc-1) + 2} = 'none';
end

legend_location2					 = 'SE';
legend_font_size2         = 16;
plot_line_widths2         = 2*ones(2*length(Kcs),1);
plot_marker_sizes2        = ones(2*length(Kcs),1); % points

plot_marker_face_colour2  = plot_line_colours2;
plot_marker_edge_colour2  = plot_marker_face_colour2;

rmsbrt_plot(X2,F2,legends2,legend_location2,legend_font_size2,plot_line_widths2,plot_line_styles2,plot_line_colours2,plot_marker_sizes2,plot_marker_types2,plot_marker_face_colour2,plot_marker_edge_colour2);
grid off; legend('RB-WMMSE', 'MaxSINR','Location','SE');


% Confidence intervals

% Can't use the standard CLT here, since the samples are correlated.
maxrate_E = zeros(length(Kcs),1); maxsinr_E = zeros(length(Kcs),1);
maxrate_baseline_E = zeros(length(Kcs),1); maxsinr_baseline_E = zeros(length(Kcs),1);
tdma_E = zeros(length(Kcs),1); unc_E = zeros(length(Kcs),1);
for ii_Kc = 1:length(Kcs)
	maxrate_std = std(vec(mean(mean(sum(sumrateKc_prec_MSr1BSr1_maxrate(:,ii_Kc,:,:,:),1),5),5)));
	maxrate_E(ii_Kc) = 1.96*maxrate_std/sqrt(Nnetworks);
	
	maxsinr_std = std(vec(mean(mean(sum(sumrateKc_prec_maxsinr(:,ii_Kc,:,:,:),1),5),4)));
	maxsinr_E(ii_Kc) = 1.96*maxsinr_std/sqrt(Nnetworks);
	
	maxrate_baseline_std = std(vec(mean(mean(sum(sumrateKc_baseline_maxrate(:,ii_Kc,:,:,:),1),5),5)));
	maxrate_baseline_E(ii_Kc) = 1.96*maxrate_baseline_std/sqrt(Nnetworks);
	
	maxsinr_baseline_std = std(vec(mean(mean(sum(sumrateKc_baseline_maxsinr(:,ii_Kc,:,:,:),1),5),4)));
	maxsinr_baseline_E(ii_Kc) = 1.96*maxsinr_baseline_std/sqrt(Nnetworks);
	
	tdma_std = std(vec(mean(mean(sum(sumrateKc_prec_baseline_tdma_inter(:,ii_Kc,:,:,:),1),5),4)));
	tdma_E(ii_Kc) = 1.96*tdma_std/sqrt(Nnetworks);
	
	unc_std = std(vec(mean(mean(sum(sumrateKc_prec_baseline_unc(:,ii_Kc,:,:,:),1),5),4)));
	unc_E(ii_Kc) = 1.96*unc_std/sqrt(Nnetworks);
end
figure; hold on;
errorbar(Kcs, sum(mean(mean(mean(sumrateKc_baseline_maxrate,5),4),3),1), maxrate_baseline_E, 'b-');
errorbar(Kcs, sum(mean(mean(mean(sumrateKc_prec_MSr1BSr1_maxrate,5),4),3),1), maxrate_E, 'b--');
errorbar(Kcs, sum(mean(mean(mean(sumrateKc_baseline_maxsinr,5),4),3),1), maxsinr_baseline_E, 'r-');
errorbar(Kcs, sum(mean(mean(mean(sumrateKc_prec_maxsinr,5),4),3),1), maxsinr_E, 'r--');
errorbar(Kcs, sum(mean(mean(mean(sumrateKc_prec_baseline_tdma_inter,5),4),3),1), tdma_E, 'c-');
errorbar(Kcs, sum(mean(mean(mean(sumrateKc_prec_baseline_unc,5),4),3),1), unc_E, 'k-');