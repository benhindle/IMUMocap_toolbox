function [meanSL, meanSR, striCNT]... 
    = get_spatiotemp(foot_fusion, event, initial_stance, end_stance)

% params = posn_locs;
str_length = zeros(end_stance - initial_stance, 1);
str_width = zeros(end_stance - initial_stance, 1);
str_dur = zeros(end_stance - initial_stance, 1);

%% Mean stride length
for i = 1:(end_stance - initial_stance)
   str_length(i) = foot_fusion.pos_n(event.IC(i + initial_stance))...
       - foot_fusion.pos_n(event.IC(i + initial_stance - 1));
   str_width(i) = foot_fusion.pos_w(event.IC(i + initial_stance))...
       - foot_fusion.pos_w(event.IC(i + initial_stance - 1));
   str_dur(i) = foot_fusion.time(event.IC(i + initial_stance))...
       - foot_fusion.time(event.IC(i + initial_stance - 1)) ;
end

meanSL = mean(str_length);
meanSW = mean(str_width);
meanSR = 1/mean(str_dur);
striCNT = end_stance - initial_stance;

%% Mean stance duration
stance_durations = zeros(end_stance - initial_stance, 1);

for k = 1:end_stance - initial_stance + 1
    stance_durations(k) = foot_fusion.time(event.EC(k + initial_stance - 1))...
        - foot_fusion.time(event.IC(k + initial_stance - 1));
end

stance_duration_mean = mean(stance_durations);

figure(1)
plot(foot_fusion.time, foot_fusion.pos_n(:, 1),...
    foot_fusion.time((event.IC(initial_stance:end_stance))), foot_fusion.pos_n((event.IC(initial_stance:end_stance)), 1), 'o');
title('Stride length')

figure(2)
    plot(foot_fusion.time(), foot_fusion.gyro_s(:, 3),...
        foot_fusion.time(event.IC(initial_stance:end_stance)), foot_fusion.gyro_s(event.IC(initial_stance:end_stance)), 'o',...
        foot_fusion.time((event.EC(initial_stance:end_stance))), foot_fusion.gyro_s((event.EC(initial_stance:end_stance)), 3), 'x')
    title('Angular vel - total trial')
    legend('', 'IC', 'EC')

figure(3)
plot(foot_fusion.time(), foot_fusion.degree(:, 1),...
    foot_fusion.time((event.IC(initial_stance:end_stance))), foot_fusion.degree((event.IC(initial_stance:end_stance)), 1), 'o',...
    foot_fusion.time((event.EC(initial_stance:end_stance))), foot_fusion.degree((event.EC(initial_stance:end_stance)), 1), 'x')
title('Sensor angle updated')
legend('', 'IC', 'EC')

figure(4)
plot(foot_fusion.time, foot_fusion.pos_w(:, 1),...
    foot_fusion.time((event.IC(initial_stance:end_stance))), foot_fusion.pos_w((event.IC(initial_stance:end_stance)), 1), 'o');
title('Stride width')

fprintf('Stride count: %.1f\n', striCNT);
fprintf('Stride length: %.3f\n', abs(meanSL));
fprintf('Stride width: %.3f\n', abs(meanSW));
fprintf('Stride rate: %.3f\n', meanSR);
fprintf('Stance duration: %.3f\n', stance_duration_mean);

end