close all
figure;
set(gcf, 'Position', [100, 100, 1000, 800]); % Adjust figure size
t = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact'); % Three plots stacked vertically

% ==========================================================
% --- First Plot ---
nexttile;
hold on;

load('No_NN.mat');
% Red highlight + main line
plot(tout, phi, '-', 'LineWidth', 15, 'Color', [0.7 0.4 0.4 0.15], 'HandleVisibility', 'off');
h1 = plot(tout, phi, '-', 'Color', [1 0 0], 'LineWidth', 2.5, 'DisplayName', 'IBVS-SMC');

load('Using_NN.mat');
% Blue highlight + main line
% plot(tout, phi, '-', 'LineWidth', 12, 'Color', [0.3 0.6 1 0.25], 'HandleVisibility', 'off'); % soft glow
h2 = plot(tout, phi, '-', 'Color', [0 0.3 1], 'LineWidth', 4.5, 'DisplayName', 'RBF-NN-IBVS-SMC');

ylabel('$\mathrm{\phi~(deg)}$', 'Interpreter', 'latex', 'FontSize', 22);
grid on;
hold off;
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 22);

% ==========================================================
% --- Second Plot ---
nexttile;
hold on;

load('No_NN.mat');
plot(tout, theta, '-', 'LineWidth', 15, 'Color', [0.7 0.4 0.4 0.15], 'HandleVisibility', 'off');
plot(tout, theta, '-', 'Color', [1 0 0], 'LineWidth', 2.5, 'DisplayName', 'IBVS-SMC');

load('Using_NN.mat');
% plot(tout, theta, '-', 'LineWidth', 8, 'Color', [0.3 0.6 1 0.25], 'HandleVisibility', 'off');
plot(tout, theta, '-', 'Color', [0 0.3 1], 'LineWidth', 4.5, 'DisplayName', 'RBF-NN-IBVS-SMC');

ylabel('$\mathrm{\theta~(deg)}$', 'Interpreter', 'latex', 'FontSize', 22);
grid on;
hold off;
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 22);

% ==========================================================
% --- Third Plot ---
nexttile;
hold on;

load('No_NN.mat');
plot(tout, psi, '-', 'LineWidth', 15, 'Color', [0.7 0.4 0.4 0.15], 'HandleVisibility', 'off');
plot(tout, psi, '-', 'Color', [1 0 0], 'LineWidth', 2.5, 'DisplayName', 'IBVS-SMC');

load('Using_NN.mat');
% plot(tout, psi, '-', 'LineWidth', 8, 'Color', [0.3 0.6 1 0.25], 'HandleVisibility', 'off');
plot(tout, psi, '-', 'Color', [0 0.3 1], 'LineWidth', 4.5, 'DisplayName', 'RBF-NN-IBVS-SMC');

xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 22);
ylabel('$\mathrm{\psi~(deg)}$', 'Interpreter', 'latex', 'FontSize', 22);
grid on;
hold off;
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 22);

% ==========================================================
ax = findall(gcf, 'Type', 'Axes'); % find all subplots
% --- Shared Legend Below ---
lgd = legend(ax(end),[h2 h1], {'RBF-NN-IBVS-SMC', 'IBVS-SMC'}, ...
    'Orientation', 'horizontal', 'Interpreter', 'latex', ...
    'FontSize', 18, 'Box', 'off');
lgd.Layout.Tile = 'north';

% ==========================================================
% --- Title Setup ---
% t.Title.String = 'Comparison of Attitude Angles With and Without NN';
t.Title.FontSize = 16;
t.Title.Interpreter = 'latex';
