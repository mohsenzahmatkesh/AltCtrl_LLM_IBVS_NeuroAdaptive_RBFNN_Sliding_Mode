close all;
figure;
set(gcf,'Position',[100,100,1500,1100]);
t = tiledlayout(4,2,'TileSpacing','compact','Padding','compact');

f1 = 'NN_LPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat';
f2 = 'NN_NoLPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat';
f3 = 'NoNN_LPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat';
f4 = 'NoNN_NoLPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat';

c1 = [0.15,0.45,0.75];
c2 = [0.85,0.20,0.20];
c3 = [0.60,0.30,0.75];
c4 = [0.55,0.55,0.55];

signals = {'u1','u2','u3','u4'};
y_labels = {'$\mathrm{u_1~(N)}$','$\mathrm{u_2~(N \cdot m)}$','$\mathrm{u_3~(N \cdot m)}$','$\mathrm{u_4~(N \cdot m)}$'};

for row = 1:4
    for col = 1:2
        nexttile;
        hold on;

        if col == 1
            data1 = load(f1); data2 = load(f2);
            h2 = plot(data2.tout,data2.(signals{row}),'Color',c2,'LineWidth',2.0,'DisplayName','RBFNN$-$IBVS$-$SMC');
            h1 = plot(data1.tout,data1.(signals{row}),'Color',c1,'LineWidth',2.5,'DisplayName','Filtered RBFNN$-$IBVS$-$SMC');
        else
            data3 = load(f3); data4 = load(f4);
            h4 = plot(data4.tout,data4.(signals{row}),'Color',c4,'LineWidth',2.0,'DisplayName','IBVS$-$SMC');
            h3 = plot(data3.tout,data3.(signals{row}),'Color',c3,'LineWidth',2.5,'DisplayName','Filtered IBVS$-$SMC');
        end

        grid on
        ylabel(y_labels{row},'Interpreter','latex','FontSize',24)
        set(gca,'TickLabelInterpreter','latex','FontSize',24)

        if row == 4
            xlabel('$\mathrm{Time~(s)}$','Interpreter','latex','FontSize',24)
        end

        hold off
    end
end

lgd = legend([h1 h2 h3 h4],{'OBS$-$RBFNN$-$IBVS$-$SMC','RBFNN$-$IBVS$-$SMC','OBS$-$IBVS$-$SMC','IBVS$-$SMC'},'Orientation','horizontal','Interpreter','latex','FontSize',22,'Box','off','NumColumns',2);
lgd.Layout.Tile = 'north';

print(gcf,'/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/Control_Inputs_Comparison.eps','-depsc','-r300');