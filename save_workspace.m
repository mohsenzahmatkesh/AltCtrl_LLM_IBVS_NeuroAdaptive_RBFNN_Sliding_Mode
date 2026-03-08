clear
% Run simulation
sim('Altitude_SMCIBVS_RBFSMC')

% ---- Read values from workspace ----
NN  = evalin('base','NN');
LPF = evalin('base','LPF');

Kp = evalin('base','Kp(1,1)');
Kd = evalin('base','Kd(1,1)');
Kq = evalin('base','Kq(1,1)');

z  = evalin('base','z');
z_final = d_final(end);

% ---- Text names ----
if NN == 1
    NNtxt = 'NN';
else
    NNtxt = 'NoNN';
end

if LPF == 1
    LPFtxt = 'LPF';
else
    LPFtxt = 'NoLPF';
end

% ---- File name ----
filename = sprintf('%s_%s_Kp_%g_Kd_%g_Kq_%g_z_%g.mat', ...
                   NNtxt, LPFtxt, Kp, Kd, Kq, z_final);

% ---- Save workspace ----
save(['/home/mohsen/AltitudeCtrl_IBVS_Neuro_Sliding_Mode/plots/' filename])