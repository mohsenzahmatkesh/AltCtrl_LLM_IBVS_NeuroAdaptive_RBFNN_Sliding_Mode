close all;
figure;
set(gcf,'Position',[100,100,1600,1400]);
t = tiledlayout(4,2,'TileSpacing','compact','Padding','compact');

fileList = {
'NN_LPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat',...
'NN_LPF_Kp_17_Kd_8_Kq_0.9_z_2.mat',...
'NN_LPF_Kp_18_Kd_8.2_Kq_0.95_z_2.mat',...
'NN_LPF_Kp_19_Kd_8.4_Kq_1_z_2.mat',...
'NN_LPF_Kp_20_Kd_8.6_Kq_1.05_z_2.mat',...
'NN_LPF_Kp_21_Kd_8.8_Kq_1.1_z_2.mat',...
'NN_LPF_Kp_22_Kd_9_Kq_1.15_z_2.mat',...
'NN_LPF_Kp_23_Kd_9.2_Kq_1.2_z_2.mat',...
'NN_LPF_Kp_24_Kd_9.4_Kq_1.25_z_2.mat'};

legend_labels = {
'$K_p=15, K_d=7.5, K_q=0.8$',...
'$K_p=17, K_d=8, K_q=0.9$',...
'$K_p=18, K_d=8.2, K_q=0.95$',...
'$K_p=19, K_d=8.4, K_q=1$',...
'$K_p=20, K_d=8.6, K_q=1.05$',...
'$K_p=21, K_d=8.8, K_q=1.1$',...
'$K_p=22, K_d=9, K_q=1.15$',...
'$K_p=23, K_d=9.2, K_q=1.2$',...
'$K_p=24, K_d=9.4, K_q=1.25$'};

colors = lines(9);

x_vars = {'x1','x2','x3','x4'};
y_vars = {'y1','y2','y3','y4'};

h = gobjects(1,9);

for row = 1:4
    for col = 1:2
        nexttile
        hold on

        if col == 1
            sig = x_vars{row};
            label_str = sprintf('$\\mathrm{x_%d~(pixels)}$',row);
            ref_idx = (row-1)*2 + 1;
        else
            sig = y_vars{row};
            label_str = sprintf('$\\mathrm{y_%d~(pixels)}$',row);
            ref_idx = (row-1)*2 + 2;
        end

        temp = load(fileList{1});
        y_ref = temp.ref(ref_idx);
        plot([0,temp.tout(end)],[y_ref,y_ref],'k--','LineWidth',2,'HandleVisibility','off');

        for i = 1:9
            data = load(fileList{i});
            h(i) = plot(data.tout,data.(sig),'Color',colors(i,:),'LineWidth',3);
        end

        grid on
        ylabel(label_str,'Interpreter','latex','FontSize',36)
        set(gca,'TickLabelInterpreter','latex','FontSize',28)

        if row == 4
            xlabel('$\mathrm{Time~(s)}$','Interpreter','latex','FontSize',36)
        end

        hold off
    end
end

lgd = legend(h,legend_labels,'Orientation','vertical','Interpreter','latex','FontSize',28,'Box','off','NumColumns',2);
lgd.Layout.Tile = 'north';