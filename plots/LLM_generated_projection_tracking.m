close all;
figure;
% High-resolution window for massive font sizes across 4 rows and 2 columns
set(gcf, 'Position', [100, 100, 1600, 1400]); 
t = tiledlayout(4, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% Corrected filenames from your uploaded files
fileList = {
    'Using_NN_LPF_15_7.5_0.8.mat', ... 
    'Using_NN_LPF_17_8_0.85.mat', ... 
    'Using_NN_LPF_18_8.2_0.9.mat'
};

% Legend labels (Stacked in three lines)
legend_labels = {
    '$K_p=15, K_d=7.5, K_q=0.8$', ...
    '$K_p=17, K_d=8, K_q=0.85$', ...
    '$K_p=18, K_d=8.2, K_q=0.9$'
};

% 3 Distinct Professional Colors
colors = [0 0.447 0.741;    % Blue
          0.85 0.325 0.098; % Red/Orange
          0.466 0.674 0.188]; % Green

% Define variable grid
% Column 1: x coordinates | Column 2: y coordinates
x_vars = {'x1', 'x2', 'x3', 'x4'};
y_vars = {'y1', 'y2', 'y3', 'y4'};

for row = 1:4
    for col = 1:2
        nexttile;
        hold on;
        
        % Determine which variable to plot
        if col == 1
            sig = x_vars{row};
            label_str = sprintf('$\\mathrm{x_%d~(pixels)}$', row);
            ref_idx = (row-1)*2 + 1; % Index in data.ref vector
        else
            sig = y_vars{row};
            label_str = sprintf('$\\mathrm{y_%d~(pixels)}$', row);
            ref_idx = (row-1)*2 + 2; % Index in data.ref vector
        end
        
        h = gobjects(1,3); % Preallocate for legend handles
        
        % Plot reference line (Dashed Black)
        % We load it from the first file
        temp = load(fileList{1});
        y_ref = temp.ref(ref_idx);
        plot([0, temp.tout(end)], [y_ref, y_ref], 'k--', 'LineWidth', 2, 'HandleVisibility', 'off');
        
        % Plot the three simulation trajectories
        for i = 1:3
            data = load(fileList{i});
            h(i) = plot(data.tout, data.(sig), 'Color', colors(i,:), 'LineWidth', 3);
        end
        
        % --- ULTRA LARGE FORMATTING FOR 0.5 TEXTWIDTH ---
        grid on;
        ylabel(label_str, 'Interpreter', 'latex', 'FontSize', 36);
        set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 28);
        
        % Only add X-label to the bottom row
        if row == 4
            xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 36);
        end
        
        hold off;
    end
end

% --- Global Legend (Three Vertical Lines) ---
lgd = legend(h, legend_labels, 'Orientation', 'vertical', ...
    'Interpreter', 'latex', 'FontSize', 28, 'Box', 'off');
lgd.Layout.Tile = 'north';