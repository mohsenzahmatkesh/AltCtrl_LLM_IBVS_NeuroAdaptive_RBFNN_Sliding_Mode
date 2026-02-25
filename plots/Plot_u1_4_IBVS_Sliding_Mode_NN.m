close all;
figure;
% Increased height to 1100 to accommodate 4 rows of plots
set(gcf, 'Position', [100, 100, 1500, 1100]); 
t = tiledlayout(4, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% Define Files
f1 = 'Using_NN_LPF.mat';    % Filtered RBFNN
f2 = 'Using_NN_NO_LPF.mat'; % RBFNN
f3 = 'No_NN_LPF.mat';       % Filtered IBVS
f4 = 'No_NN_NO_LPF.mat';    % IBVS

% --- Color Definitions ---
% Left Column: Intelligent Control (Blue and Red)
c1 = [0.15, 0.45, 0.75];      % Medium Blue   (Filtered RBFNN - TOP)
c2 = [0.85, 0.20, 0.20];      % Medium Red    (RBFNN - BOTTOM)

% Right Column: Baseline Control (Purple and Gray)
c3 = [0.60, 0.30, 0.75];      % Medium Purple (Filtered IBVS - TOP)
c4 = [0.55, 0.55, 0.55];      % Slate Gray    (IBVS - BOTTOM)

% Signals and Y-labels with \mathrm{} format and specific units
signals = {'u1', 'u2', 'u3', 'u4'};
y_labels = {'$\mathrm{u_1~(N)}$', '$\mathrm{u_2~(N \cdot m)}$', ...
            '$\mathrm{u_3~(N \cdot m)}$', '$\mathrm{u_4~(N \cdot m)}$'};

for row = 1:4
    for col = 1:2
        nexttile;
        hold on;
        
        if col == 1
            % --- Left Column: Intelligent Control (NN) ---
            data1 = load(f1); data2 = load(f2);
            
            % Plot c2 (Bottom) first, then c1 (Top)
            h2 = plot(data2.tout, data2.(signals{row}), 'Color', c2, 'LineWidth', 2.0, ...
                'DisplayName', 'RBFNN$-$IBVS$-$SMC');
            h1 = plot(data1.tout, data1.(signals{row}), 'Color', c1, 'LineWidth', 2.5, ...
                'DisplayName', 'Filtered RBFNN$-$IBVS$-$SMC');
            
            if row == 1, title('Intelligent Control', 'Interpreter', 'latex', 'FontSize', 18); end
        else
            % --- Right Column: Baseline Control (SMC) ---
            data3 = load(f3); data4 = load(f4);
            
            % Plot c4 (Bottom) first, then c3 (Top)
            h4 = plot(data4.tout, data4.(signals{row}), 'Color', c4, 'LineWidth', 2.0, ...
                'DisplayName', 'IBVS$-$SMC');
            h3 = plot(data3.tout, data3.(signals{row}), 'Color', c3, 'LineWidth', 2.5, ...
                'DisplayName', 'Filtered IBVS$-$SMC');
                
            if row == 1, title('Baseline Control', 'Interpreter', 'latex', 'FontSize', 18); end
        end
        
        % Formatting
        grid on;
        ylabel(y_labels{row}, 'Interpreter', 'latex', 'FontSize', 22);
        
        % TickLabelInterpreter set to latex for real minus signs on axes
        set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 18);
        
        if row == 4
            xlabel('$\mathrm{Time~(s)}$', 'Interpreter', 'latex', 'FontSize', 22);
        end
        hold off;
    end
end

% Global Legend with math mode minus signs
lgd = legend([h1 h2 h3 h4], ...
    {'Filtered RBFNN$-$IBVS$-$SMC', 'RBFNN$-$IBVS$-$SMC', 'Filtered IBVS$-$SMC', 'IBVS$-$SMC'}, ...
    'Orientation','horizontal', 'Interpreter','latex', ...
    'FontSize',20, 'Box','off', 'NumColumns', 2);
lgd.Layout.Tile = 'north';