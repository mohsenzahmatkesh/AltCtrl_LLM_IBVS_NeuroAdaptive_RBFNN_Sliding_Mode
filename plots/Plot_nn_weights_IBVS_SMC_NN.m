close all;
figure;
% High-resolution window for massive font sizes
set(gcf, 'Position', [100, 100, 1500, 1100]); 
t = tiledlayout(2, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

% Load the specific file
data = load('Using_NN_LPF_18_8.2_0.9.mat');
time = data.tout; % 3001 steps

% --- Data Preparation ---
% Reshaping from [40, 4, 3001] to [160, 3001] then transposing for plot [3001, 160]
W_plot = reshape(data.W_nn, [], length(time))';
W_dot_plot = reshape(data.W_dot_nn, [], length(time))';

% --- Top Plot: Neural Network Weights (W_nn) ---
nexttile;
hold on;
plot(time, W_plot, 'LineWidth', 1.0); 
grid on;
ylabel('$\hat{W}_{nn}$', 'Interpreter', 'latex', 'FontSize', 36);
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 28);
hold off;

% --- Lower Plot: Weight Derivatives (W_dot_nn) ---
nexttile;
hold on;
plot(time, W_dot_plot, 'LineWidth', 1.0); 
grid on;
ylabel('$\dot{\hat{W}}_{nn}$', 'Interpreter', 'latex', 'FontSize', 36);
xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 36);
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 28);
hold off;

% No legend included to avoid cluttering the 160 signals