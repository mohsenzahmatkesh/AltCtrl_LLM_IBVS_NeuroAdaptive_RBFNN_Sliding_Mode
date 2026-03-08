close all;
figure;
set(gcf,'Position',[100,100,1500,1100]);
t = tiledlayout(4,2,'TileSpacing','compact','Padding','compact');

fileGroups = {
    { ...
    'NN_LPF_Kp_1.5_Kd_4_Kq_0.6_z_10.mat',...
    'NN_LPF_Kp_2_Kd_4.5_Kq_0.7_z_10.mat'};

    { ...
    'NN_LPF_Kp_4_Kd_6.5_Kq_0.9_z_6.mat',...
    'NN_LPF_Kp_5_Kd_7_Kq_1_z_6.mat'};

    { ...
    'NN_LPF_Kp_6_Kd_7.5_Kq_1_z_4.mat',...
    'NN_LPF_Kp_8_Kd_8.5_Kq_1.1_z_4.mat',...
    'NN_LPF_Kp_11_Kd_9.2_Kq_1.18_z_4.mat'};

    { ...
    'NN_LPF_Kp_15_Kd_7.5_Kq_0.8_z_2.mat',...
    'NN_LPF_Kp_24_Kd_9.4_Kq_1.25_z_2.mat'}
};

legendGroups = {
    { ...
    '$K_p=1.5, K_d=4, K_q=0.6,\ z_d=10~(\mathrm{m})$',...
    '$K_p=2, K_d=4.5, K_q=0.7,\ z_d=10~(\mathrm{m})$'};

    { ...
    '$K_p=4, K_d=6.5, K_q=0.9,\ z_d=6~(\mathrm{m})$',...
    '$K_p=5, K_d=7, K_q=1,\ z_d=6~(\mathrm{m})$'};

    { ...
    '$K_p=6, K_d=7.5, K_q=1,\ z_d=4~(\mathrm{m})$',...
    '$K_p=8, K_d=8.5, K_q=1.1,\ z_d=4~(\mathrm{m})$',...
    '$K_p=11, K_d=9.2, K_q=1.18,\ z_d=4~(\mathrm{m})$'};

    { ...
    '$K_p=15, K_d=7.5, K_q=0.8,\ z_d=2~(\mathrm{m})$',...
    '$K_p=24, K_d=9.4, K_q=1.25,\ z_d=2~(\mathrm{m})$'}
};

titles_z = [10 6 4 2];

colors = [
    0.0000    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840
    0.0000    0.0000    0.0000
    1.0000    0.0000    1.0000
];

signals = {'x','y'};
ylabels = {'$\mathrm{x~(m)}$','$\mathrm{y~(m)}$'};

globalColorIdx = {
    [1 2]
    [3 4]
    [5 6 7]
    [8 9]
};

legendHandles = [];
legendTexts = {};

for r = 1:4
    for c = 1:2
        nexttile;
        hold on;

        files_this_group = fileGroups{r};
        labels_this_group = legendGroups{r};
        color_idx_this_group = globalColorIdx{r};

        localHandles = gobjects(1,length(files_this_group));

        for i = 1:length(files_this_group)
            data = load(files_this_group{i});
            localHandles(i) = plot(data.tout, data.(signals{c}), ...
                'Color', colors(color_idx_this_group(i),:), 'LineWidth', 2.5);
        end

        if c == 1
            legendHandles = [legendHandles localHandles];
            legendTexts = [legendTexts labels_this_group];
        end

        grid on
        ylabel(ylabels{c},'Interpreter','latex','FontSize',24)
        set(gca,'TickLabelInterpreter','latex','FontSize',24)
        title(sprintf('$z_d=%g~(\\mathrm{m})$', titles_z(r)), ...
            'Interpreter','latex','FontSize',24)

        if r == 4
            xlabel('$\mathrm{Time~(s)}$','Interpreter','latex','FontSize',24)
        end

        hold off
    end
end

lgd = legend(legendHandles,legendTexts, ...
    'Orientation','horizontal', ...
    'Interpreter','latex', ...
    'FontSize',22, ...
    'Box','off', ...
    'NumColumns',2);
lgd.Layout.Tile = 'north';

print(gcf,'/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/XY_Comparison_All_Z.eps','-depsc','-r300');