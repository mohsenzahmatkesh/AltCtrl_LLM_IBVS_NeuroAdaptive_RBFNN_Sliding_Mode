close all
figure;
set(gcf, 'Position', [100, 100, 1000, 800]); % Adjust figure size
t = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact'); % Three plots stacked vertically

% First Plot
nexttile;
hold on;
load('Using_NN.mat');
plot(tout, phi, 'b-', 'LineWidth', 2.5, 'DisplayName', 'Using RBFNN');
load("No_NN.mat")
plot(tout, phi, 'r--', 'LineWidth', 2.5, 'DisplayName', 'Without RBFNN');
% title('Plot 1: Variable Comparison', 'Interpreter', 'latex', 'FontSize', 14);
% xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 34);
ylabel('$\phi^{\circ}$', 'Interpreter', 'latex', 'FontSize', 22);
grid on;
legend('Location', 'best', 'Interpreter', 'latex', 'FontSize', 16);
hold off;
set(gca,  'TickLabelInterpreter', 'latex', 'FontSize', 22);

% Second Plot
nexttile;
hold on;
load('Using_NN.mat');
plot(tout, theta,'b-', 'LineWidth', 2.5, 'DisplayName', 'Using RBFNN');
load("No_NN.mat")
plot(tout, theta, 'r--', 'LineWidth', 2.5, 'DisplayName', 'Without RBFNN');
% title('Plot 2: Variable Comparison', 'Interpreter', 'latex', 'FontSize', 14);
% xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 24);
ylabel('$\theta^{\circ}$', 'Interpreter', 'latex', 'FontSize', 22);
grid on;
% legend('Location', 'best', 'Interpreter', 'latex', 'FontSize', 16);
hold off;
set(gca,  'TickLabelInterpreter', 'latex', 'FontSize', 22);

% Third Plot
nexttile;
hold on;
load('Using_NN.mat');
plot(tout, psi,'b-', 'LineWidth', 2.5, 'DisplayName', 'Using RBFNN');
load("No_NN.mat")
plot(tout, psi, 'r--', 'LineWidth', 2.5, 'DisplayName', 'Without RBFNN');
% title('Plot 3: Variable Comparison', 'Interpreter', 'latex', 'FontSize', 14);
xlabel('Time (s)', 'Interpreter', 'latex', 'FontSize', 22);
ylabel('$\psi^{\circ}$', 'Interpreter', 'latex', 'FontSize', 22);
grid on;
% legend('Location', 'best', 'Interpreter', 'latex', 'FontSize', 16);
hold off;
set(gca,  'TickLabelInterpreter', 'latex', 'FontSize', 22);
% Adjust layout title if needed
% t.Title.String = 'Comparison of Variables With and Without NN';
t.Title.FontSize = 16;
t.Title.Interpreter = 'latex';
