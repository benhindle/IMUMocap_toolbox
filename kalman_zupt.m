function [C, vel_n, pos_n, P] = kalman_zupt(t, P, H, R, C, pos_n, vel_n)

    %%% Kalman filter zero-velocity update %%%
            % Kalman gain.
            K = (P * (H)')/((H) * P * (H)' + R);
            
            % Filter state update.
            del_x = K * vel_n(:,t);
            
            % Update error covariance matrix in Joseph form for symmetry.
            P = (eye(9) - K * (H)) * P * (eye(9) - K*(H))' + K * R * K';
            
            % Extract errors from the KF state.
            attitude_error = del_x(1:3);
            position_error = del_x(4:6);
            velocity_error = del_x(7:9);
            
            %%% Correct INS estimates. %%%
            % Correct orientation using skew-symmetric matrix for small angles.
            ang_matrix = -[0   -attitude_error(3,1)   attitude_error(2,1);
                attitude_error(3, 1)  0   -attitude_error(1, 1);
                -attitude_error(2, 1)  attitude_error(1, 1)  0];
            
            % Correct orientation.
            C = (2*eye(3)+(ang_matrix))/(2*eye(3)-(ang_matrix))*C;
            
            % Correct position and velocity based on K error estimate.
            vel_n(:,t)=vel_n(:,t)-velocity_error;
            pos_n(:,t)=pos_n(:,t)-position_error;
    
    end