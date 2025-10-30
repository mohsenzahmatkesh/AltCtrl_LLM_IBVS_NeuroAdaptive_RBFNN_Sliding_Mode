close all
figure;
set(gcf, 'Position', [100, 100, 1000, 800]);
tiledlayout(1, 1, 'Padding', 'none', 'TileSpacing', 'none'); % Remove all margins

% Load and plot data from Using_NN.mat
load('Using_NN.mat');

ref_x = ref(1, 1:2:end);
ref_y = ref(1, 2:2:end);
ref_z = [1.95 1.95 1.95 1.95];

projection_x = projection(:, [1, 4, 7, 10]);
projection_y = projection(:, [2, 5, 8, 11]);
projection_z = -projection(:, [3, 6, 9, 12]);

first_projection_x = projection_x(1, :);
first_projection_y = projection_y(1, :);
first_projection_z = projection_z(1, :);

nexttile;
plot3(ref_x, ref_y, ref_z, 'o', 'MarkerSize', 18, 'MarkerEdgeColor', [0.6, 0.1, 0.1], 'MarkerFaceColor', [0.6, 0.1, 0.1]);
hold on;
plot3(first_projection_x, first_projection_y, first_projection_z, 'o', 'MarkerSize', 18, 'MarkerEdgeColor', [0, 0.15, 0.5], 'MarkerFaceColor', [0, 0.15, 0.5]);
hold on;
plot3(projection_x, projection_y, projection_z,'b',  'LineWidth', 3.5);
hold on;

% Load and plot data from No_NN.mat without clearing workspace
load('No_NN.mat');

projection_x = projection(:, [1, 4, 7, 10]);
projection_y = projection(:, [2, 5, 8, 11]);
projection_z = -projection(:, [3, 6, 9, 12]);

plot3(projection_x, projection_y, projection_z, 'r--', 'LineWidth', 3.5);

legend('Reference Features', 'Initial Features', 'IBVS-NNSMC', '', '', '', 'IBVS-SMC','Interpreter', 'latex', 'FontSize', 16, 'Location', 'northwest');
xlabel('$X$', 'Interpreter', 'latex', 'FontSize', 22);
ylabel('$Y$', 'Interpreter', 'latex', 'FontSize', 22);
zlabel('$Z$ (m)', 'Interpreter', 'latex', 'FontSize', 22);
grid on;
set(gca,  'TickLabelInterpreter', 'latex', 'FontSize', 22);
axis equal;

% Adjust the angle of view
view(80, 8);

hold off;
