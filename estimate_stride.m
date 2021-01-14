function footFusion = estimate_stride(footFusion, q_os, event)
global CALIBRATION_START_TIME CALIBRATION_END_TIME GYRO_THRESHOLD

%% Data from foot mounted sensor - use data KF section start

acc = footFusion.accArray;
gyro = footFusion.gyroArray;
time = footFusion.time;

gyro_bias = mean(gyro(CALIBRATION_START_TIME : CALIBRATION_END_TIME, :))';

data_size = length(acc);
timestamp = time'; % Timestamps of measurements.

acc_s = acc'; % Accelerations in sensor frame.
gyro_s = gyro'; % Rates of turn in sensor frame.

footFusion.gyro_s = gyro_s';

g = -9.81; % Gravity. 

%% Initialise parameters.
% Orientation from accelerometers. Sensor is assumed to be stationary.
pitch = -asin(acc_s(1,1)/g);
roll = atan(acc_s(2,1)/acc_s(3,1));
yaw = 0;

C = [cos(pitch)*cos(yaw) (sin(roll)*sin(pitch)*cos(yaw))-(cos(roll)*sin(yaw)) (cos(roll)*sin(pitch)*cos(yaw))+(sin(roll)*sin(yaw));
    cos(pitch)*sin(yaw)  (sin(roll)*sin(pitch)*sin(yaw))+(cos(roll)*cos(yaw))  (cos(roll)*sin(pitch)*sin(yaw))-(sin(roll)*cos(yaw));
    -sin(pitch) sin(roll)*cos(pitch) cos(roll)*cos(pitch)];
C_prev = C;


% Preallocate storage for accelerations in navigation frame.
acc_n = nan(3, data_size);
acc_n(:,1) = C*acc_s(:,1);


% Preallocate storage for velocity (in navigation frame).
% Initial velocity assumed to be zero.
vel_n = nan(3, data_size);
vel_n(:,1) = [0 0 0]';

% Preallocate storage for position (in navigation frame).
% Initial position arbitrarily set to the origin.
pos_n = nan(3, data_size);
pos_n(:,1) = [0 0 0]';

% Preallocate storage for distance travelled used for altitude plots.
distance = nan(2,data_size-1);
distance(1) = 0;
distance(2) = 0;

% Error covariance matrix.
P = zeros(9);

% Process noise parameter, gyroscope and accelerometer noise.
sigma_omega = 1e-2; sigma_a = 1e-2;

% ZUPT measurement matrix.
H = [zeros(3) zeros(3) eye(3)];

% ZUPT measurement noise covariance matrix.
sigma_v = 1e-2;
R = diag([sigma_v sigma_v sigma_v]).^2;


%% Main Loop
for t = 2:data_size
    %%% Start INS (transformation, double integration) %%%
    dt = timestamp(t) - timestamp(t-1);
    
    % Remove bias from gyro measurements.
    gyro_s1 = gyro_s(:,t) - gyro_bias;
    
    % Skew-symmetric matrix for angular rates
    ang_rate_matrix = [0   -gyro_s1(3)   gyro_s1(2);
        gyro_s1(3)  0   -gyro_s1(1);
        -gyro_s1(2)  gyro_s1(1)  0];
    
    % orientation estimation
    C = C_prev*(2*eye(3)+(ang_rate_matrix*dt))/(2*eye(3)-(ang_rate_matrix*dt));
    
    % Transforming the acceleration from sensor frame to navigation frame.
    acc_n(:,t) = 0.5*(C + C_prev)*acc_s(:,t);
        
    % Velocity and position estimation using trapezoid integration.
    vel_n(:,t) = vel_n(:,t-1) + ((acc_n(:,t) - [0; 0; g] )+(acc_n(:,t-1) - [0; 0; g]))*dt/2;
    pos_n(:,t) = pos_n(:,t-1) + (vel_n(:,t) + vel_n(:,t-1))*dt/2;
    
    % Skew-symmetric cross-product operator matrix formed from the n-frame accelerations.
    S = [0  -acc_n(3,t)  acc_n(2,t);
        acc_n(3,t)  0  -acc_n(1,t);
        -acc_n(2,t) acc_n(1,t) 0];
    
    % State transition matrix.
    F = [eye(3)  zeros(3,3)    zeros(3,3);
        zeros(3,3)   eye(3)  dt*eye(3);
        -dt*S  zeros(3,3)    eye(3) ];
    
    % Compute the process noise covariance Q.
    Q = diag([sigma_omega sigma_omega sigma_omega 0 0 0 sigma_a sigma_a sigma_a]*dt).^2;
    
    % Propagate the error covariance matrix.
    P = F*P*F' + Q;
        
    % Stance phase detection and zero-velocity updates.
    if( (norm(gyro_s(:,t)) < GYRO_THRESHOLD) )
       [C, vel_n, pos_n, P] = kalman_zupt(t, P, H, R, C, pos_n, vel_n); 
    end
    
    C_prev = C; % Save orientation estimate, required at start of main loop.
    
    % Compute horizontal distance.
    distance(1,t) = distance(1,t-1) + sqrt((pos_n(1,t)-pos_n(1,t-1))^2 + (pos_n(2,t)-pos_n(2,t-1))^2);
    distance(2,t) = distance(2,t-1) + (pos_n(2,t) - pos_n(2,t-1)) * sin(asin((pos_n(1,t) - pos_n(1,t-1))/(distance(1,t) - distance(1,t-1))));
    
end

footFusion.pos_n = distance(1, :)';
footFusion.pos_w = distance(2, :)';

%% Plot acc, vel and position estimates

figure(1)
subplot(3,1,1)
plot(timestamp, acc_n)
title('acc n')

subplot(3,1,2)
plot(timestamp, vel_n,...
    footFusion.time(event.IC), vel_n(1, event.IC'), 'o',...
    footFusion.time(event.EC), vel_n(1, event.EC'), 'x')
title('vel n')

subplot(3,1,3)
plot(timestamp, distance(1,:),'LineWidth',2,'Color','b');
xlabel('Time (s)');
ylabel('Stride length x direction (m)');
title('Stride length');


figure(2)
plot(timestamp, acc_n)
title('acc n')
grid;

figure(3)
plot(timestamp, distance(1,:),...
    footFusion.time(event.IC), distance(1, event.IC'), 'o',...
    footFusion.time(event.EC), distance(1, event.EC'), 'x');
xlabel('Time (s)');
ylabel('Stride length x direction (m)');
title('Stride length');
legend('', 'IC', 'EC')

end