function orientation = orientation_glob(dataLowg, dataMag, magCalFilename,...
    CALIBRATION_START_TIME, CALIBRATION_END_TIME, SENSOR)

time = dataLowg(CALIBRATION_START_TIME:CALIBRATION_END_TIME, 1);
accX = dataLowg(CALIBRATION_START_TIME:CALIBRATION_END_TIME, 2);
accY = dataLowg(CALIBRATION_START_TIME:CALIBRATION_END_TIME, 3);
accZ = dataLowg(CALIBRATION_START_TIME:CALIBRATION_END_TIME, 4);
gyroX = dataLowg(CALIBRATION_START_TIME:CALIBRATION_END_TIME, 5);
gyroY = dataLowg(CALIBRATION_START_TIME:CALIBRATION_END_TIME, 6);
gyroZ = dataLowg(CALIBRATION_START_TIME:CALIBRATION_END_TIME, 7);
magX = dataMag(CALIBRATION_START_TIME:CALIBRATION_END_TIME, 1);
magY = dataMag(CALIBRATION_START_TIME:CALIBRATION_END_TIME, 2);
magZ = dataMag(CALIBRATION_START_TIME:CALIBRATION_END_TIME, 3);

gyroArray = [gyroX, gyroY, gyroZ];
gyroArray = gyroArray * (pi / 180); %conv to rad/s
accArray = [accX, accY, accZ];
magArray = [magX, magY, magZ];

magCalFile = csvread(magCalFilename, 1, 0);

magCalX = magCalFile(:, 3);
magCalY = magCalFile(:, 4);
magCalZ = magCalFile(:, 5);
magCalArray = [magCalX, magCalY, magCalZ];

[bmcA, bmcB, EXPECTED_MAGNETIC_FS] = magcal(magCalArray, 'sym');

magArrayCorrected = (magArray - bmcB) * bmcA;

ahrsfilt = ahrsfilter();

if (strcmp(SENSOR, "foot"))
    ahrsfilt.SampleRate = 1125;
    ahrsfilt.AccelerometerNoise = 0.00192; 
    ahrsfilt.MagnetometerNoise = 0.1;
    ahrsfilt.GyroscopeNoise =  0.000917;
    ahrsfilt.GyroscopeDriftNoise = 3.05e-13;
    ahrsfilt.LinearAccelerationNoise = 0.0096236;
    ahrsfilt.LinearAccelerationDecayFactor = 0.35;
    ahrsfilt.MagneticDisturbanceNoise = 0.99;
    ahrsfilt.MagneticDisturbanceDecayFactor = 0.99;
    ahrsfilt.ExpectedMagneticFieldStrength = EXPECTED_MAGNETIC_FS

 elseif (strcmp(SENSOR, "proximal"))
    ahrsfilt.SampleRate = 1125;
    ahrsfilt.AccelerometerNoise = 0.00192; 
    ahrsfilt.MagnetometerNoise = 0.1;
    ahrsfilt.GyroscopeNoise =  0.000917;
    ahrsfilt.GyroscopeDriftNoise = 3.05e-13;
    ahrsfilt.LinearAccelerationNoise = 0.0096236;
    ahrsfilt.LinearAccelerationDecayFactor = 0.35;
    ahrsfilt.MagneticDisturbanceNoise = 0.99;
    ahrsfilt.MagneticDisturbanceDecayFactor = 0.99;
    ahrsfilt.ExpectedMagneticFieldStrength = EXPECTED_MAGNETIC_FS

elseif (strcmp(SENSOR, "distal"))
    ahrsfilt.SampleRate = 1125;
    ahrsfilt.AccelerometerNoise = 0.00192; 
    ahrsfilt.MagnetometerNoise = 0.1;
    ahrsfilt.GyroscopeNoise =  0.000917;
    ahrsfilt.GyroscopeDriftNoise = 3.05e-13;
    ahrsfilt.LinearAccelerationNoise = 0.0096236;
    ahrsfilt.LinearAccelerationDecayFactor = 0.35;
    ahrsfilt.MagneticDisturbanceNoise = 0.99;
    ahrsfilt.MagneticDisturbanceDecayFactor = 0.99;
    ahrsfilt.ExpectedMagneticFieldStrength = EXPECTED_MAGNETIC_FS

elseif (strcmp(SENSOR, "base"))
    ahrsfilt.SampleRate = 1125;
    ahrsfilt.AccelerometerNoise = 0.00192; 
    ahrsfilt.MagnetometerNoise = 0.1;
    ahrsfilt.GyroscopeNoise =  0.000917;
    ahrsfilt.GyroscopeDriftNoise = 3.05e-13;
    ahrsfilt.LinearAccelerationNoise = 0.0096236;
    ahrsfilt.LinearAccelerationDecayFactor = 0.35;
    ahrsfilt.MagneticDisturbanceNoise = 0.99;
    ahrsfilt.MagneticDisturbanceDecayFactor = 0.99;
    ahrsfilt.ExpectedMagneticFieldStrength = EXPECTED_MAGNETIC_FS

else
    ahrsfilt.SampleRate = 1125;
    ahrsfilt.AccelerometerNoise = 0.00192;
    ahrsfilt.MagnetometerNoise = 0.1;
    ahrsfilt.GyroscopeNoise =  0.000917;
    ahrsfilt.GyroscopeDriftNoise = 3.05e-13;
    ahrsfilt.LinearAccelerationNoise = 0.0096236;
    ahrsfilt.LinearAccelerationDecayFactor = 0.35;
    ahrsfilt.MagneticDisturbanceNoise = 0.99;
    ahrsfilt.MagneticDisturbanceDecayFactor = 0.99;
    ahrsfilt.ExpectedMagneticFieldStrength = EXPECTED_MAGNETIC_FS

 end

fusion = ahrsfilt(accArray, gyroArray, magArrayCorrected);

orientation.fusion = fusion;
orientation.accArray = accArray;
orientation.gyroArray = gyroArray;
orientation.magArrayCorrected = magArrayCorrected;
orientation.time = time;

reset(ahrsfilter)

end