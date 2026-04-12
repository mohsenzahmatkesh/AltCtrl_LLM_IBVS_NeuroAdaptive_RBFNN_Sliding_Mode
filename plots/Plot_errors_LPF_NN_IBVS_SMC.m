close all;
figure;
% High-resolution window for massive font sizes
set(gcf, 'Position', [100, 100, 1500, 1100]); 
t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% Define the 4 Simulation Files
fileList = {
    'NN_LPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat',     % Top Left
    'NN_NoLPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat',  % Top Right
    'NoNN_LPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat',        % Bottom Left
    'NoNN_NoLPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat'      % Bottom Right
};

titles = {
    'OBS$-$RBFNN$-$IBVS$-$SMC', ...
    'RBFNN$-$IBVS$-$SMC', ...
    'OBS$-$IBVS$-$SMC', ...
    'IBVS$-$SMC'
};

% Error variables to plot
x_err_vars = {'x1_err', 'x2_err', 'x3_err', 'x4_err'};
y_err_vars = {'y1_err', 'y2_err', 'y3_err', 'y4_err'};

% Color palette: Blues for X-errors, Reds/Oranges for Y-errors
colors_x = [0 0.447 0.741; 0 0 1; 0.3 0.75 0.93; 0 0.2 0.5];
colors_y = [0.85 0.325 0.098; 1 0 0; 0.635 0.078 0.184; 1 0.5 0];

for i = 1:4
    nexttile;
    hold on;
    
    data = load(fileList{i});
    h = gobjects(8,1); % To store handles for legend
    
    % Plot X-errors (Blue family)
    for k = 1:4
        h(k) = plot(data.tout, data.(x_err_vars{k}), 'Color', colors_x(k,:), 'LineWidth', 2);
    end
    
    % Plot Y-errors (Red family)
    for k = 1:4
        h(k+4) = plot(data.tout, data.(y_err_vars{k}), 'Color', colors_y(k,:), 'LineWidth', 2);
    end
    
    % --- Apply requested ylim logic ---
    if i == 1
        ylim([-0.001, 0.001]); % First tile: -0.01 to +0.01
    elseif i == 2 
        ylim([-0.001, 0.001]);   % Second and Third tiles: -0.1 to 0.1
    elseif i == 3
        ylim([-0.005, 0.005]);
    elseif i == 4
        ylim([-0.005, 0.005]);
    end
    % Fourth tile (i=4) remains unchanged as requested
    
    % --- ULTRA LARGE FORMATTING FOR 0.5 TEXTWIDTH ---
    grid on;
    set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 36);
    title(titles{i}, 'Interpreter', 'latex', 'FontSize', 28);
    if i == 1 || i == 3
        ylabel('$\mathrm{Image~Error}$', 'Interpreter', 'latex', 'FontSize', 36);
    end
    
    if i == 3 || i == 4
        xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 36);
    end
    
    
    hold off;
end

% --- Massive Legend for the whole Figure ---
legend_labels = {'$x_{1,e}$', '$x_{2,e}$', '$x_{3,e}$', '$x_{4,e}$', ...
                 '$y_{1,e}$', '$y_{2,e}$', '$y_{3,e}$', '$y_{4,e}$'};
lgd = legend(h, legend_labels, 'Orientation', 'horizontal', ...
    'Interpreter', 'latex', 'FontSize', 34, 'Box', 'off', 'NumColumns', 4);
lgd.Layout.Tile = 'north';

outname = '/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/Image_Error_Comparison.eps';
print(gcf, outname, '-depsc', '-r300');