close all;
figure;
set(gcf,'Position',[100,100,1500,1100]);
t = tiledlayout(4,2,'TileSpacing','compact','Padding','compact');

f1 = 'NN_LPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat';
f2 = 'NN_NoLPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat';

est_signals = {'delta_h_phi','delta_h_theta','delta_h_psi','delta_h_z'};
act_signals = {'delta_phi','delta_theta','delta_psi','delta_z'};

y_labels = {'$\mathrm{\phi-\hat{\phi}~(deg)}$',...
            '$\mathrm{\theta-\hat{\theta}~(deg)}$',...
            '$\mathrm{\psi-\hat{\psi}~(deg)}$',...
            '$\mathrm{z-\hat{z}~(m)}$'};

for row = 1:4
    for col = 1:2
        nexttile;
        hold on;

        if col == 1
            data = load(f1);
            h1 = plot(data.tout,data.(est_signals{row}),'-','Color',[1 0 0],'LineWidth',2.5);
        else
            data = load(f2);
            h3 = plot(data.tout,data.(est_signals{row}),'-','Color',[0 0 1],'LineWidth',2.5);
        end

        h2 = plot(data.tout,data.(act_signals{row}),'k--','LineWidth',2.2);

        grid on
        set(gca,'TickLabelInterpreter','latex','FontSize',36)

        if col == 1
            ylabel(y_labels{row},'Interpreter','latex','FontSize',36)
        end

        if row == 4
            xlabel('$\mathrm{Time~(s)}$','Interpreter','latex','FontSize',36)
        end

        hold off
    end
end

lgd = legend([h2 h1 h3],...
{'${\Delta}^{\ast}$',...
'$\hat{\Delta}_{\mathrm{OBS\_RBFNN\_IBVS\_SMC}}$',...
'$\hat{\Delta}_{\mathrm{RBFNN\_IBVS\_SMC}}$'},...
'Orientation','horizontal','Interpreter','latex',...
'FontSize',34,'Box','off');
lgd.Layout.Tile = 'north';

print(gcf,'/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/Disturbance_Estimation_Comparison.eps','-depsc','-r300');