close all;
figure;
set(gcf, 'Position', [100, 100, 1500, 900]); 
t = tiledlayout(3, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% Define Files
f1 = 'Using_NN_LPF.mat';    % Filtered RBFNN
f2 = 'Using_NN_NO_LPF.mat'; % RBFNN
f3 = 'No_NN_LPF.mat';       % Filtered IBVS
f4 = 'No_NN_NO_LPF.mat';    % IBVS

% --- Color Definitions ---
% Left Column (Intelligent)
c1 = [0.15, 0.45, 0.75];      % Medium Blue   (Filtered RBFNN - TOP)
c2 = [0.85, 0.20, 0.20];      % Medium Purple (RBFNN - BOTTOM)

% Right Column (Baseline)
c3 = [0.60, 0.30, 0.75];      % Medium Red    (Filtered IBVS - TOP)
c4 = [0.55, 0.55, 0.55];      % Slate Gray    (IBVS - BOTTOM)

signals = {'phi', 'theta', 'psi'};
y_labels = {'$\mathrm{\phi~(deg)}$', '$\mathrm{\theta~(deg)}$', '$\mathrm{\psi~(deg)}$'};

for row = 1:3
    for col = 1:2
        nexttile;
        hold on;
        
        if col == 1
            % --- Left Column: RBFNN Variants ---
            data1 = load(f1); data2 = load(f2);
            
            % Plot c2 (Bottom) first, then c1 (Top)
            h2 = plot(data2.tout, data2.(signals{row}), 'Color', c2, 'LineWidth', 2.5, ...
                'DisplayName', 'RBFNN-IBVS-SMC');
            h1 = plot(data1.tout, data1.(signals{row}), 'Color', c1, 'LineWidth', 3, ...
                'DisplayName', 'Filtered RBFNN-IBVS-SMC');
            
            if row == 1, title('Intelligent Control', 'Interpreter', 'latex', 'FontSize', 18); end
        else
            % --- Right Column: Standard SMC Variants ---
            data3 = load(f3); data4 = load(f4);
            
            % Plot c4 (Bottom) first, then c3 (Top)
            h4 = plot(data4.tout, data4.(signals{row}), 'Color', c4, 'LineWidth', 2.5, ...
                'DisplayName', 'IBVS-SMC');
            h3 = plot(data3.tout, data3.(signals{row}), 'Color', c3, 'LineWidth', 3, ...
                'DisplayName', 'Filtered IBVS-SMC');
                
            if row == 1, title('Baseline Control', 'Interpreter', 'latex', 'FontSize', 18); end
        end
        
        % Formatting
        grid on;
        ylabel(y_labels{row}, 'Interpreter', 'latex', 'FontSize', 20);
        set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 16);
        if row == 3
            xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 20);
        end
        hold off;
    end
end

% Global Legend
lgd = legend([h1 h2 h3 h4], ...
    {'Filtered RBFNN-IBVS-SMC', 'RBFNN-IBVS-SMC', 'Filtered IBVS-SMC', 'IBVS-SMC'}, ...
    'Orientation','horizontal', 'Interpreter','latex', ...
    'FontSize',18, 'Box','off', 'NumColumns', 2);
lgd.Layout.Tile = 'north';