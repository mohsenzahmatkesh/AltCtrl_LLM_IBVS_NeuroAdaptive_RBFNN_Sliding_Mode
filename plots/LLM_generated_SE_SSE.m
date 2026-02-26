close all;
figure;
% High-resolution window for massive font sizes
set(gcf, 'Position', [100, 100, 1500, 1100]); 
t = tiledlayout(2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

% Corrected filenames from your uploaded files
fileList = {
    'Using_NN_LPF_15_7.5_0.8.mat', ... 
    'Using_NN_LPF_17_8_0.85.mat', ... 
    'Using_NN_LPF_18_8.2_0.9.mat'
};

% Legend labels using LaTeX math mode
legend_labels = {
    '$K_p=15, K_d=7.5, K_q=0.8$', ...
    '$K_p=17, K_d=8, K_q=0.85$', ...
    '$K_p=18, K_d=8.2, K_q=0.9$'
};

% 3 Distinct Professional Colors
colors = [0 0.447 0.741;    % Blue
          0.85 0.325 0.098; % Red/Orange
          0.466 0.674 0.188]; % Green

% --- Top Plot: SE (Sum of Errors) ---
nexttile;
hold on;
h = gobjects(1,3); % Preallocate for legend handles
for i = 1:3
    data = load(fileList{i});
    h(i) = plot(data.tout, data.SE, 'Color', colors(i,:), 'LineWidth', 3);
end
grid on;
ylabel('$\mathrm{SE}$', 'Interpreter', 'latex', 'FontSize', 36);
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 28);

% Set x-axis limit for SE plot as requested
xlim([0, 1]); 

hold off;

% --- Lower Plot: SSE (Sum of Squared Errors) ---
nexttile;
hold on;
for i = 1:3
    data = load(fileList{i});
    plot(data.tout, data.SSE, 'Color', colors(i,:), 'LineWidth', 3);
end
grid on;
ylabel('$\mathrm{SSE}$', 'Interpreter', 'latex', 'FontSize', 36);
xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 36);
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 28);
hold off;

% --- Global Legend (Three Vertical Lines) ---
% Removing 'Orientation', 'horizontal' and using 'vertical' (default)
lgd = legend(h, legend_labels, 'Orientation', 'vertical', ...
    'Interpreter', 'latex', 'FontSize', 28, 'Box', 'off');
lgd.Layout.Tile = 'north';