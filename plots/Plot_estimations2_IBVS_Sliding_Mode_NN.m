close all;
figure;
% High resolution window for large text
set(gcf, 'Position', [100, 100, 1500, 1100]); 
t = tiledlayout(4, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% Define Files (Estimation only exists in NN versions)
f1 = 'Using_NN_LPF.mat';    
f2 = 'Using_NN_NO_LPF.mat'; 

% Signal Arrays
est_signals = {'delta_h_phi', 'delta_h_theta', 'delta_h_psi', 'delta_h_z'};
act_signals = {'delta_phi', 'delta_theta', 'delta_psi', 'delta_z'};

% Y-Labels (Massive scaling for 0.5\textwidth)
y_labels = {'$\mathrm{\phi-\hat{\phi}~(deg)}$', ...
            '$\mathrm{\theta-\hat{\theta}~(deg)}$', ...
            '$\mathrm{\psi-\hat{\psi}~(deg)}$', ...
            '$\mathrm{z-\hat{z}~(m)}$'};

for row = 1:4
    for col = 1:2
        nexttile;
        hold on;
        
        if col == 1
            data = load(f1);
            col_title = 'Filtered Estimation';
        else
            data = load(f2);
            col_title = 'Unfiltered Estimation';
        end
        
        % 1. Plot Estimated Disturbance (Solid Red)
        h1 = plot(data.tout, data.(est_signals{row}), '-', 'Color', [1 0 0], ...
            'LineWidth', 2.5, 'DisplayName', '$\hat{\Delta}~(Estimated)$');
        
        % 2. Plot Actual Disturbance (Black Dashed)
        h2 = plot(data.tout, data.(act_signals{row}), 'k--', ...
            'LineWidth', 2.2, 'DisplayName', '${\Delta}~(Implemented)$');
        
        % --- ULTRA LARGE FORMATTING FOR SCALING ---
        grid on;
        % Y-Label increased to 36 for high visibility
        ylabel(y_labels{row}, 'Interpreter', 'latex', 'FontSize', 36);
        
        % Axis Ticks increased to 28
        set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 28);
        
        if row == 1
            title(col_title, 'Interpreter', 'latex', 'FontSize', 32);
        end
        
        if row == 4
            % X-Label increased to 36
            xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 36);
        end
        hold off;
    end
end

% --- Massive Legend Scaling ---
% Using mathematical minus signs $-$
lgd = legend([h2 h1], {'${\Delta}~(Implemented)$', '$\hat{\Delta}~(Estimated)$'}, ...
    'Orientation', 'horizontal', 'Interpreter', 'latex', ...
    'FontSize', 32, 'Box', 'off');
lgd.Layout.Tile = 'north';