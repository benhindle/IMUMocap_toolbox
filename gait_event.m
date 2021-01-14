function event = gait_event(footFusion, t_start, t_end)

event.IC = []; event.EC = [];

% PARAMETERS TO BE TUNED
IC_WIND_UP = 0.11; % initial contact window upper bound
IC_WIND_LO = 0.11; % initial contact window lower bound
EC_WIND_UP = 0.05; % end contact window upper bound
EC_WIND_LO = 0.25; % end contact window lower bound

EC_min_pk_dist = 0.22; % end contact peak minimum distance
EC_min_pk_height = 20; % end contact peak average minimum hight

IC_min_pk_dist = 0.40; % initial contact peak average minimum distance
IC_min_pk_height = -7; % initial contact peak average minimum hight

EC_pk_av_min_dist = 0.30 % end contact peak average minimum distance
EC_pk_av_min_height = 1 % end contact peak average minimum height
IC_pk_av_min_dist = 0.22 % initial contact peak average minimum distance
IC_pk_av_min_height = 0 % initial contact peak average minimum height

[~,frame_start] = min( abs( footFusion.time - t_start ) );
[~,frame_end] = min( abs( footFusion.time - t_end ) );

% Get peak plantar angle of foot sensor (EC+)
[~, locs_pplant] = findpeaks(footFusion.degree(frame_start:frame_end, 1),... 
    footFusion.time(frame_start:frame_end),...
    'MinPeakDistance', EC_min_pk_dist, 'MinPeakHeight', EC_min_pk_height);

% Get peak dorsi angle of foot sensor (IC-)
[~, locs_pdorsi] = findpeaks(-footFusion.degree(frame_start:frame_end, 1),... 
    footFusion.time(frame_start:frame_end),...
    'MinPeakDistance', IC_min_pk_dist, 'MinPeakHeight', IC_min_pk_height);

% Establish IC (initial contact) and EC (end contact) window bounds
locs_IC = zeros(length(locs_pplant), 1);
locs_EC = zeros(length(locs_pplant), 1);
 
%FIGURE 1
angle_EC_indx = zeros(length(locs_pplant), 1);
angle_IC_indx = zeros(length(locs_pdorsi), 1);
for j = 1:length(locs_pplant)
    [~, angle_EC_indx(j)] = min( abs( footFusion.time - locs_pplant(j)));
end
for j = 1:length(locs_pdorsi)
    [~, angle_IC_indx(j)] = min( abs( footFusion.time - locs_pdorsi(j)));
end

figure(1)
plot(footFusion.time(), footFusion.degree(:,1), footFusion.time(angle_IC_indx), footFusion.degree(angle_IC_indx), 'o',...
footFusion.time(angle_EC_indx), footFusion.degree(angle_EC_indx), 'x')
title('Sensor angle')
legend('', 'IC', 'EC')
    
for i = 1:length(locs_pplant)
    [~, window_start_EC] = min( abs( footFusion.time - (locs_pplant(i) - EC_WIND_LO) ));
    [~, window_end_EC] = min( abs( footFusion.time - (locs_pplant(i) + EC_WIND_UP) ));
    [~, window_start_IC] = min( abs( footFusion.time - (locs_pdorsi(i) - IC_WIND_LO) ));
    [~, window_end_IC] = min( abs( footFusion.time - (locs_pdorsi(i) + IC_WIND_UP) ));
        
    figure(2)
    plot(footFusion.time(window_start_EC:window_end_EC),...
        footFusion.gyro_s(window_start_EC:window_end_EC, 3))
    title('Angular vel - window')
    
    % Peak angular velocity (plantflex ang vel -)
    [~, locs_EC(i)] = findpeaks(-footFusion.gyro_s(window_start_EC:window_end_EC, 3),... 
    footFusion.time(window_start_EC:window_end_EC),...
    'MinPeakDistance', EC_pk_av_min_dist, 'MinPeakHeight', EC_pk_av_min_height);
    
    % First zero crossing of angular velocity AFTER minimum dorsi for EC window (plant)
    [~, locs_IC(i)] = findpeaks(footFusion.gyro_s(window_start_IC:window_end_IC, 3),... 
    footFusion.time(window_start_IC:window_end_IC),...
    'MinPeakDistance', IC_pk_av_min_dist, 'MinPeakHeight', IC_pk_av_min_height);
    [~, locs_IC_after_peak] = min( abs( footFusion.time - locs_IC(i)) );
    zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);
    zci_indices = zci(footFusion.gyro_s(locs_IC_after_peak:window_end_IC, 3));
    locs_IC(i) = zci_indices(1) + locs_IC_after_peak;

end
    
%% Add to event array
locs_EC_indx = zeros(length(locs_IC), 1);
for k = 1:length(locs_IC)   
    [~, hip_EC_index] = min( abs( footFusion.time - locs_EC(k)) );
    locs_EC_indx(k) = hip_EC_index;
end

event_IC = event.IC;
event_EC = event.EC;

event.IC = [event_IC; locs_IC]
event.EC = [event_EC; locs_EC_indx]


end