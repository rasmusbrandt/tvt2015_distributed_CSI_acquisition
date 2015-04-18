function figure_handle = rmsbrt_figure(fig_size, x_label, y_label, x_lim, y_lim, x_ticks, y_ticks)

% Heavily inspired by Damiano Varagnolo
% http://www.ee.kth.se/~damiano/matlab.html


figure_handle = figure;


% ===============
% General setup
% ===============


set(gcf, 'Units', 'centimeters'); 


figure_position_on_screen = [20 20 fig_size];  % [pos_x pos_y width_x width_y]
set(gcf, 'Position', figure_position_on_screen); % [left bottom width height]

set(gcf, 'PaperPositionMode', 'auto');


% ===============
% Font settings
% ===============

font_size         = 16;
font_unit         = 'points'; % [{points} | normalized | inches | centimeters | pixels]
font_name         = 'Helvetica';
font_weight       = 'normal'; % [light | {normal} | demi | bold]
font_angle        = 'normal'; % [{normal} | italic | oblique]     ps: only for axes 
axes_interpreter  = 'tex';    % [{tex} | latex | none]
axes_line_width   = 1.0;      % width of the line of the axes


% ===============
% Set up axes
% ===============


set(gca,                                     ...
    'XGrid',                'on',            ... [on | {off}]
    'YGrid',                'on',            ... [on | {off}]
    'GridLineStyle',        ':',             ... [- | -- | {:} | -. | none]
    'XMinorGrid',           'off' ,          ... [on | {off}]
    'YMinorGrid',           'off',           ... [on | {off}]
    'MinorGridLineStyle',   ':',             ... [- | -- | {:} | -. | none]
    ...
    'XTick',                x_ticks,         ... ticks of x axis
    'YTick',                y_ticks,         ... ticks of y axis
    ... 'XTickLabel',           {'-1','0','1'},  ...
    ... 'YTickLabel',           {'-1','0','1'},  ...
    'XMinorTick',           'off' ,          ... [on | {off}]
    'YMinorTick',           'off',           ... [on | {off}]
    'TickDir',              'out',           ... [{in} | out] inside or outside (for 2D)
    'TickLength',           [.02 .02],       ... length of the ticks
    ...
    'XColor',               [.1 .1 .1],      ... color of x axis
    'YColor',               [.1 .1 .1],      ... color of y axis
    'XAxisLocation',        'bottom',        ... where labels have to be printed [top | {bottom}]
    'YAxisLocation',        'left',          ... where labels have to be printed [left | {right}]
    'XDir',                 'normal',        ... axis increasement direction [{normal} | reverse]
    'YDir',                 'normal',        ... axis increasement direction [{normal} | reverse]
    'XLim',                 x_lim,           ... limits for the x-axis
    'YLim',                 y_lim,           ... limits for the y-axis
    ...
    'FontName',             font_name,       ... kind of fonts of labels
    'FontSize',             font_size,       ... size of fonts of labels
    'FontUnits',            font_unit,       ... units of the size of fonts
    'FontWeight',           font_weight,     ... weight of fonts of labels
    'FontAngle',            font_angle,      ... inclination of fonts of labels
    ...
    'LineWidth',            axes_line_width);  % width of the line of the axes


% ===============
% Label settings
% ===============

x_label_angle = 0.0;
y_label_angle = 90.0;

xlabel( x_label,                       ...
        'FontName',     font_name,     ...
        'FontUnit',     font_unit,     ...
        'FontSize',     font_size,     ...
        'FontWeight',   font_weight,   ...
        'Interpreter',  axes_interpreter);
ylabel( y_label,                       ...
        'FontName',     font_name,     ...
        'FontUnit',     font_unit,     ...
        'FontSize',     font_size,     ...
        'FontWeight',   font_weight,   ...
        'Interpreter',  axes_interpreter);
			
set(get(gca, 'XLabel'), 'Rotation', x_label_angle);
set(get(gca, 'YLabel'), 'Rotation', y_label_angle);

% we want to plot several curves
hold on;

end
