clc
clear

model = 'Altitude_SMCIBVS_RBFSMC';

load_system(model);

for k = 1
    fprintf('Running simulation %d...\n', k);
    sim(model);
    errs = {x1_err,y1_err,x2_err,y2_err,x3_err,y3_err,x4_err,y4_err};
    names = {'x1','y1','x2','y2','x3','y3','x4','y4'};

    overshoot = struct();

    for i = 1:numel(errs)
        e = errs{i};
        e0 = abs(e(1));                 % initial error
        peak = max(abs(e));             % peak error magnitude
        os = max(0, (peak - e0) / max(e0, eps)) * 100;
        overshoot.(names{i}) = os;
    end

    disp('Overshoot percentages:')
    disp(overshoot)


    settlePct = 0.02;              % 2%
    settle = struct();

    t = tout;

    for i = 1:numel(errs)
        e = abs(errs{i});          % use magnitude for settling
        ef = e(end);              % final value (simple)

        band = settlePct * max(eps, abs(e(1) - ef));
        upper = ef + band;

        idx = find(e > upper, 1, 'last');   % last time outside band
        if isempty(idx)
            ts = 0;
        elseif idx >= numel(t)
            ts = t(end);
        else
            ts = t(idx+1);                 % first time after last violation
        end

        settle.(names{i}) = ts;
    end

    disp('Settling time (s):')
    disp(settle)


    save('ibvs_errors.mat', ...
     'tout','SE','SSE', ...
     'x1_err','y1_err','x2_err','y2_err','x3_err','y3_err','x4_err','y4_err', ...
     'overshoot','settle');



end

close_system(model, 0);
clear 
load("ibvs_errors.mat")
