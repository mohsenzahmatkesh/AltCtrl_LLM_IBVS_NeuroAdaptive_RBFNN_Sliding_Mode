close all;
figure;
set(gcf,'Position',[100,100,1500,1100]);
t = tiledlayout(2,1,'TileSpacing','compact','Padding','compact');

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

nexttile;
hold on;
h = gobjects(1,9);
for i = 1:9
    data = load(fileList{i});
    h(i) = plot(data.tout,data.SE,'Color',colors(i,:),'LineWidth',3);
end
grid on;
ylabel('$\mathrm{SE}$','Interpreter','latex','FontSize',36);
set(gca,'TickLabelInterpreter','latex','FontSize',36);
xlim([0,1]);
hold off;

nexttile;
hold on;
for i = 1:9
    data = load(fileList{i});
    plot(data.tout,data.SSE,'Color',colors(i,:),'LineWidth',3);
end
grid on;
ylabel('$\mathrm{SSE}$','Interpreter','latex','FontSize',36);
xlabel('$\mathrm{Time~(s)}$','Interpreter','latex','FontSize',36);
set(gca,'TickLabelInterpreter','latex','FontSize',36);
hold off;

lgd = legend(h,legend_labels,'Orientation','vertical','Interpreter','latex','FontSize',34,'Box','off','NumColumns',2);
lgd.Layout.Tile = 'north';

print(gcf,'/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/SE_SSE_Gain_Comparison.eps','-depsc','-r300');

figure;
set(gcf,'Position',[100,100,1500,1100]);
hold on;

for i = 1:9
    data = load(fileList{i});
    plot(data.tout,data.SE,'Color',colors(i,:),'LineWidth',3);
end

grid on;
ylabel('$\mathrm{SE}$','Interpreter','latex','FontSize',36);
% xlabel('$\mathrm{Time~(s)}$','Interpreter','latex','FontSize',36);
set(gca,'TickLabelInterpreter','latex','FontSize',28);

xlim([0.04 0.085]);
ylim([31.5 32.6]);

print(gcf,'/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/SE_Zoom_Gain_Comparison.eps','-depsc','-r300');

figMain = figure(1);
figZoom = figure(2);

axZoomSource = findobj(figZoom,'Type','axes');

axInset = copyobj(axZoomSource,figMain);

set(axInset,'Units','normalized','Position',[0.6,0.6,0.35,0.22],'FontSize',36);

box(axInset,'on');

print(figMain,'/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/SE_SSE_Merged.eps','-depsc','-r300');