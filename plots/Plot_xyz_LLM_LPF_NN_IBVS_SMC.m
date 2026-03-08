close all;
figure;
set(gcf,'Position',[100,100,1500,1100]);
t = tiledlayout(3,1,'TileSpacing','compact','Padding','compact');

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

signals = {'x','y','z'};
y_labels = {'$\mathrm{x~(m)}$','$\mathrm{y~(m)}$','$\mathrm{z~(m)}$'};

for row = 1:3
    ax(row) = nexttile;
    hold(ax(row),'on')

    h = gobjects(1,9);

    for i = 1:9
        data = load(fileList{i});
        h(i) = plot(ax(row),data.tout,data.(signals{row}),'Color',colors(i,:),'LineWidth',3);
    end

    grid(ax(row),'on')
    ylabel(ax(row),y_labels{row},'Interpreter','latex','FontSize',38)
    set(ax(row),'TickLabelInterpreter','latex','FontSize',38)

    if row == 3
        xlabel(ax(row),'$\mathrm{Time~(s)}$','Interpreter','latex','FontSize',38)
    end

    hold(ax(row),'off')
    xlim([0 10])
end

pos = ax(3).Position;

axInset = axes('Position',[pos(1)+0.60*pos(3), pos(2)+0.38*pos(4), 0.30*pos(3), 0.45*pos(4)]);
hold(axInset,'on')

for i = 1:9
    data = load(fileList{i});
    plot(axInset,data.tout,data.z,'Color',colors(i,:),'LineWidth',2);
end

grid(axInset,'on')
set(axInset,'TickLabelInterpreter','latex','FontSize',36)

ylim(axInset,[1.9 2])
xlim(axInset,[4 7])

box(axInset,'on')

print(gcf,'/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/LLM_xyz_with_z_inset.eps','-depsc','-r300');