close all;
figure;
set(gcf,'Position',[100,100,1500,900]);
t = tiledlayout(3,2,'TileSpacing','compact','Padding','compact');

f1 = 'NN_LPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat';
f2 = 'NN_NoLPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat';
f3 = 'NoNN_LPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat';
f4 = 'NoNN_NoLPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat';

c1 = [0.15,0.45,0.75];
c2 = [0.85,0.20,0.20];
c3 = [0.60,0.30,0.75];
c4 = [0.55,0.55,0.55];

signals = {'phi','theta','psi'};
y_labels = {'$\mathrm{\phi~(deg)}$','$\mathrm{\theta~(deg)}$','$\mathrm{\psi~(deg)}$'};

for row = 1:3
    for col = 1:2
        nexttile;
        hold on;

        if col == 1
            data1 = load(f1); data2 = load(f2);
            h2 = plot(data2.tout,data2.(signals{row}),'Color',c2,'LineWidth',2.5,'DisplayName','RBFNN-IBVS-SMC');
            h1 = plot(data1.tout,data1.(signals{row}),'Color',c1,'LineWidth',3,'DisplayName','Filtered RBFNN-IBVS-SMC');
        else
            data3 = load(f3); data4 = load(f4);
            h4 = plot(data4.tout,data4.(signals{row}),'Color',c4,'LineWidth',2.5,'DisplayName','IBVS-SMC');
            h3 = plot(data3.tout,data3.(signals{row}),'Color',c3,'LineWidth',3,'DisplayName','Filtered IBVS-SMC');
        end

        grid on;
        ylabel(y_labels{row},'Interpreter','latex','FontSize',24);
        set(gca,'TickLabelInterpreter','latex','FontSize',24);

        if row == 3
            xlabel('$\mathrm{Time~(s)}$','Interpreter','latex','FontSize',24);
        end

        hold off;
    end
end

lgd = legend([h1 h2 h3 h4],{'Filtered RBFNN-IBVS-SMC','RBFNN-IBVS-SMC','Filtered IBVS-SMC','IBVS-SMC'},'Orientation','horizontal','Interpreter','latex','FontSize',22,'Box','off','NumColumns',2);
lgd.Layout.Tile = 'north';

outname = '/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/PhiThetaPsi_Control_Comparison.eps';
print(gcf,outname,'-depsc','-r300');