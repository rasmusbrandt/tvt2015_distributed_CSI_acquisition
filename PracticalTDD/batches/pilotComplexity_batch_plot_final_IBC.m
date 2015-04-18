% Build figure
figure; hold on;
figure_position_on_screen = [20 20 20 9];  % [pos_x pos_y width_x width_y]
set(gcf, 'Units', 'centimeters'); 
set(gcf, 'Position', figure_position_on_screen); % [left bottom width height]
set(gcf, 'PaperPositionMode', 'auto');

linewidth = 2.5;

% Plot it
line(Nps,mean(sum(pilotComplexity_full_maxrate,1),3),'Color',rgb('Navy'),'LineStyle','-','Marker','none','LineWidth',linewidth);
line(Nps,mean(sum(pilotComplexity_precGLOB_maxrate,1),3),'Color',rgb('Navy'),'LineStyle','--','Marker','none','LineWidth',linewidth);
line(Nps,mean(sum(pilotComplexity_prec_maxrate,1),3),'Color',rgb('Navy'),'LineStyle',':','Marker','none','LineWidth',linewidth);
haxes1 = gca; box off;
set(haxes1,'XGrid','off','YGrid','off');
set(haxes1,'XLim',[12 100],'XTick',[12 20:10:100]);
set(haxes1,'YLim',[24 30],'YTick',24:30);
set(haxes1,'FontSize',16);
xlabel('Number of pilots N_{p,d} = N_{p,u}','FontSize',16);
ylabel('Average sum rate [bits/s/Hz]','FontSize',16);
l = legend('Sec. III-C', 'Sec. III-B', 'Sec. III-A','Location','NorthWest');
set(l,'FontSize',16);

haxes1_pos = get(haxes1,'Position'); % store position of first axes
haxes2 = axes('Position',haxes1_pos,...
              'XAxisLocation','top',...
							'XTickLabel',[], ...
              'YAxisLocation','right',...
              'Color','none','FontSize',16);
set(haxes2,'XGrid','off','YGrid','off');
set(haxes2,'XLim',[12 100],'XTick',[12 20:10:100]);
set(haxes2,'YLim',[0 5],'YTick',0:5);

box off;
set(gca,'YaxisLocation','right');

line(Nps,pilotComplexity_full_flops/1000,'Color',rgb('RoyalBlue'),'LineStyle','-','LineWidth',linewidth);
line(Nps,pilotComplexity_precGLOB_flops/1000,'Color',rgb('RoyalBlue'),'LineStyle','--','LineWidth',linewidth);
line(Nps,pilotComplexity_prec_flops/1000,'Color',rgb('RoyalBlue'),'LineStyle',':','LineWidth',linewidth);
line(Nps,pilotComplexity_RBWMMSE_flops/1000,'Color',rgb('Black'),'LineStyle','-','LineWidth',linewidth);
ylabel('Number of kiloflops','FontSize',16);


export_fig pilotComplexity_IBC.pdf

