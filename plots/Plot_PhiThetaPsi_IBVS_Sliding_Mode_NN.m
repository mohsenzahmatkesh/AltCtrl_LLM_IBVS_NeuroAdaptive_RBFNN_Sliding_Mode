close all;
figure;
set(gcf, 'Position', [100, 100, 1400, 900]); % Wider figure for two columns
t = tiledlayout(3, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% Define file groups for clarity
% Column 1: No Low Pass Filter
files_col1 = {'No_NN_NO_LPF.mat', 'Using_NN_NO_LPF.mat'}; 
% Column 2: With Low Pass Filter
files_col2 = {'No_NN_LPF.mat', 'Using_NN_LPF.mat'}; 

signals = {'phi', 'theta', 'psi'};
y_labels = {'$\phi~(deg)$', '$\theta~(deg)$', '$\psi~(deg)$'};
col_titles = {'Without Low Pass Filter', 'With Low Pass Filter'};

for row = 1:3
    for col = 1:2
        nexttile;
        hold on;
        
        % Determine which files to load based on column
        if col == 1
            current_files = files_col1;
        else
            current_files = files_col2;
        end
        
        % 1. Plot Baseline (IBVS-SMC) - Red
        data_base = load(current_files{1});
        plot(data_base.tout, data_base.(signals{row}), '-', 'LineWidth', 12, ...
            'Color', [0.7 0.4 0.4 0.15], 'HandleVisibility', 'off'); % Glow
        h1 = plot(data_base.tout, data_base.(signals{row}), '-', 'Color', [1 0 0], ...
            'LineWidth', 2.2, 'DisplayName', 'IBVS-SMC');
        
        % 2. Plot Proposed (RBF-NN-IBVS-SMC) - Blue
        data_nn = load(current_files{2});
        h2 = plot(data_nn.tout, data_nn.(signals{row}), '-', 'Color', [0 0.3 1], ...
            'LineWidth', 3.5, 'DisplayName', 'RBFNN-IBVS-SMC');
        
        % --- Formatting ---
        grid on;
        ylabel(y_labels{row}, 'Interpreter', 'latex', 'FontSize', 20);
        set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 18);
        
        % Add column titles to the top row only
        if row == 1
            title(col_titles{col}, 'Interpreter', 'latex', 'FontSize', 20);
        end
        
        % Add X-label to the bottom row only
        if row == 3
            xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 20);
        end
        
        hold off;
    end
end

% Global Legend at the top
lgd = legend([h2 h1], {'RBFNN-IBVS-SMC','IBVS-SMC'}, ...
    'Orientation','horizontal', 'Interpreter','latex', ...
    'FontSize',20, 'Box','off');
lgd.Layout.Tile = 'north';
