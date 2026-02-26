close all;
figure;
% High-resolution window for massive font sizes across 3 rows
set(gcf, 'Position', [100, 100, 1500, 1200]); 
t = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

% Corrected filenames from your uploaded files
fileList = {
    'Using_NN_LPF_15_7.5_0.8.mat', ... 
    'Using_NN_LPF_17_8_0.85.mat', ... 
    'Using_NN_LPF_18_8.2_0.9.mat'
};

% Legend labels (Three vertical lines)
legend_labels = {
    '$K_p=15, K_d=7.5, K_q=0.8$', ...
    '$K_p=17, K_d=8, K_q=0.85$', ...
    '$K_p=18, K_d=8.2, K_q=0.9$'
};

% 3 Distinct Professional Colors
colors = [0 0.447 0.741;    % Blue
          0.85 0.325 0.098; % Red/Orange
          0.466 0.674 0.188]; % Green

% Signals and Y-labels with \mathrm{} format
signals = {'phi', 'theta', 'psi'};
y_labels = {'$\mathrm{\phi~(deg)}$', '$\mathrm{\theta~(deg)}$', '$\mathrm{\psi~(deg)}$'};

for row = 1:3
    nexttile;
    hold on;
    
    h = gobjects(1,3); % Preallocate for legend handles
    for i = 1:3
        data = load(fileList{i});
        % Plotting each file for the current attitude angle
        h(i) = plot(data.tout, data.(signals{row}), 'Color', colors(i,:), 'LineWidth', 3);
    end
    
    % --- ULTRA LARGE FORMATTING FOR 0.5 TEXTWIDTH ---
    grid on;
    ylabel(y_labels{row}, 'Interpreter', 'latex', 'FontSize', 36);
    
    % Set axis ticks to latex for mathematical minus signs
    set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 28);
    
    % Only add X-label to the bottom plot
    if row == 3
        xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 36);
    end
    
    hold off;
end

% --- Global Legend (Three Vertical Lines) ---
lgd = legend(h, legend_labels, 'Orientation', 'vertical', ...
    'Interpreter', 'latex', 'FontSize', 28, 'Box', 'off');
lgd.Layout.Tile = 'north';