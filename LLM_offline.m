clc
% clear

% model = 'Altitude_SMCIBVS_RBFSMC';

% load_system(model);

for k = 1
    fprintf('Running simulation %d...\n', k);
    % sim(model);
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

    % ===================== SE DECAY METRICS =====================
    t = tout(:);
    se = abs(SE(:));                 % SE should be >=0, abs for safety

    SE_decay = struct('peak',NaN,'t_peak',NaN,'tau',NaN,'t90',NaN,'t_settle2',NaN);

    if numel(se) < 5
        disp('SE decay metrics not meaningful (too short).');
    else
        se0 = se(1);

        % 1) Peak error (early bump)
        [SE_decay.peak, ip] = max(se);
        SE_decay.t_peak = t(ip);

        % 2) Time constant tau: first time SE <= 0.368*SE0
        target_tau = 0.368 * se0;
        itau = find(se <= target_tau, 1, 'first');
        if ~isempty(itau)
            SE_decay.tau = t(itau);
        end

        % 3) 90% decay time: first time SE <= 0.1*SE0
        target_90 = 0.10 * se0;
        i90 = find(se <= target_90, 1, 'first');
        if ~isempty(i90)
            SE_decay.t90 = t(i90);
        end

        % 4) 2% settling time: first time after which SE stays <= 0.02*SE0
        target_settle = 0.02 * se0;
        out = se > target_settle;
        idx = find(out, 1, 'last');   % last time outside the band
        if isempty(idx)
            SE_decay.t_settle2 = 0;
        elseif idx >= numel(t)
            SE_decay.t_settle2 = t(end);
        else
            SE_decay.t_settle2 = t(idx+1);
        end
    end

    disp('SE decay metrics:')
    disp(SE_decay)
    % ============================================================



    
    % save('ibvs_errors.mat', ...
    %      'tout','SE','SSE', ...
    %      'x1_err','y1_err','x2_err','y2_err','x3_err','y3_err','x4_err','y4_err', ...
    %      'overshoot','settle','SE_decay');




end

% close_system(model, 0);
% clear 
% load("ibvs_errors.mat")
