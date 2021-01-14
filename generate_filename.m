function fileName = generate_filename(exercise, date, trial, sensor_location, data_type, mag_cal_iteration)

if (strcmp(data_type, 'lowg'))
   data_type = "__lowg.csv";
elseif (strcmp(data_type, 'highg'))
   data_type = "__highg.csv";
    
elseif (strcmp(data_type, 'mag'))
    data_type = "__mag.csv";
else
    trial = 'MC' + string(sensor_location{1}(end-1:end)) + mag_cal_iteration;
    data_type = "__mag.csv";
end
fileName = 'Data/' + exercise + '/' + date + '/' + trial + '_' + sensor_location + data_type;

end
