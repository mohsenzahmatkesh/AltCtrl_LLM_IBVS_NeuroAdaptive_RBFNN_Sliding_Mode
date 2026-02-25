close all;
figure;
% Set figure size for a 4x2 page-wide layout
set(gcf, 'Position', [100, 100, 1500, 1100]); 
t = tiledlayout(4, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% Define Files (Estimation only exists in NN versions)
f1 = 'Using_NN_LPF.mat';    % Column 1: Filtered
f2 = 'Using_NN_NO_LPF.mat'; % Column 2: Unfiltered

% Signal Arrays
est_signals = {'delta_h_phi', 'delta_h_theta', 'delta_h_psi', 'delta_h_z'};
act_signals = {'delta_phi', 'delta_theta', 'delta_psi', 'delta_z'};

% Y-Labels with \mathrm{} format and mathematical minus signs
y_labels = {'$\mathrm{\phi-\hat{\phi}~(deg)}$', ...
            '$\mathrm{\theta-\hat{\theta}~(deg)}$', ...
            '$\mathrm{\psi-\hat{\psi}~(deg)}$', ...
            '$\mathrm{z-\hat{z}~(m)}$'};

for row = 1:4
    for col = 1:2
        nexttile;
        hold on;
        
        % Select file based on column
        if col == 1
            data = load(f1);
            col_title = 'Filtered Estimation';
        else
            data = load(f2);
            col_title = 'Unfiltered Estimation';
        end
        
        % 1. Plot Estimated Disturbance (Solid Red)
        h1 = plot(data.tout, data.(est_signals{row}), '-', 'Color', [1 0 0], ...
            'LineWidth', 2.2, 'DisplayName', '$\hat{\Delta}~(Estimated)$');
        
        % 2. Plot Actual Disturbance (Black Dashed)
        h2 = plot(data.tout, data.(act_signals{row}), 'k--', ...
            'LineWidth', 2.0, 'DisplayName', '${\Delta}~(Implemented)$');
        
        % --- Formatting ---
        grid on;
        ylabel(y_labels{row}, 'Interpreter', 'latex', 'FontSize', 22);
        
        % Axis Ticks set to latex for proper minus signs on numbers
        set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 18);
        
        % Column Titles for the first row only
        if row == 1
            title(col_title, 'Interpreter', 'latex', 'FontSize', 20);
        end
        
        % X-label for the last row only
        if row == 4
            xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 22);
        end
        
        hold off;
    end
end

% --- Shared Legend at the Top ---
lgd = legend([h2 h1], {'${\Delta}~(Implemented)$', '$\hat{\Delta}~(Estimated)$'}, ...
    'Orientation', 'horizontal', 'Interpreter', 'latex', ...
    ... % Using math mode $-$ for minus signs in text
    'FontSize', 20, 'Box', 'off');
lgd.Layout.Tile = 'north';