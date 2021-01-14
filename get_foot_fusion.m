function footFusion = get_foot_fusion(q_os, data, foot_magcal_filename)
global CALIBRATION_START_TIME CALIBRATION_END_TIME TRIAL_START_TIME SEQUENCE_OF_INTEREST

%% Foot sensor static data
footStaticFusion = orientation_glob(data.footLowg, data.footMag, foot_magcal_filename, CALIBRATION_START_TIME, CALIBRATION_END_TIME, 'foot');

% Establish transformation quaternion of distal sensor in the segment frame
footOriginOrientQuat = quatmultiply(quatconj(q_os), compact(meanrot(footStaticFusion.fusion)));

%% Foot sensor movement data
footFusion = orientation_glob(data.footHighg, data.footLowg, data.footMag, foot_magcal_filename, TRIAL_START_TIME, length(data.footLowg), 'foot');

% Transform orientation of distal sensor into segment frame at each time point
footFusion.orientQuat = quaternion(quatmultiply(quatnormalize(compact(footFusion.fusion)), quatconj(footOriginOrientQuat)));
footFusion.degree = eulerd(footFusion.orientQuat, SEQUENCE_OF_INTEREST, 'frame');

footFusion.gyro_s = (quat2dcm(q_os) * footFusion.gyroArray.')';
footFusion.acc_s = (quat2dcm(q_os) * footFusion.accArray.')';

end