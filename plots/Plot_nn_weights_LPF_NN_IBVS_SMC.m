close all;
figure;
set(gcf,'Position',[100,100,1500,1100]);
t = tiledlayout(2,1,'TileSpacing','compact','Padding','compact');

data = load('NN_LPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat');
time = data.tout;

W_plot = reshape(data.W_nn,[],length(time))';
W_dot_plot = reshape(data.W_dot_nn,[],length(time))';

nexttile;
hold on;
plot(time,W_plot,'LineWidth',1.0);
grid on;
set(gca,'TickLabelInterpreter','latex','FontSize',36);
ylabel('$\hat{W}_{nn}$','Interpreter','latex','FontSize',36);
hold off;

nexttile;
hold on;
plot(time,W_dot_plot,'LineWidth',1.0);
grid on;
set(gca,'TickLabelInterpreter','latex','FontSize',36);
ylabel('$\dot{\hat{W}}_{nn}$','Interpreter','latex','FontSize',36);
xlabel('$\mathrm{Time~(s)}$','Interpreter','latex','FontSize',36);
hold off;

print(gcf,'/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/NN_Weights_And_Derivatives.eps','-depsc','-r300');