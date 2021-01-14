
global JUMP_START_TIME JUMP_END_TIME CALIBRATION_START_TIME CALIBRATION_END_TIME TRIAL_START_TIME SEQUENCE_OF_INTEREST GYRO_THRESHOLD

DATE = "210115";
TRIAL = "T01";
EXERCISE = "";
SAMPLE_RATE = 1125; %(Hz)

PROXIMAL_SENSOR = "01216"
DISTAL_SENSOR = "01226"
BASE_SENSOR = "01246"
FOOT_SENSOR = "01246"

JUMP_START_TIME = 1 % first frame
JUMP_END_TIME = 9000 % frame number
CALIBRATION_START_TIME = round(1) % frame number
CALIBRATION_END_TIME = round(10000) % frame number
TRIAL_START_TIME = 1 % frame number
GYRO_THRESHOLD = 3
SEQUENCE_OF_INTEREST = "YXZ"

filenames.distalMagCal = generate_filename(EXERCISE, DATE, TRIAL, DISTAL_SENSOR, 'MC', MAG_CAL);
filenames.proximalMagCal = generate_filename(EXERCISE, DATE, TRIAL, PROXIMAL_SENSOR, 'MC', MAG_CAL);
filenames.baseMagCal = generate_filename(EXERCISE, DATE, TRIAL, BASE_SENSOR, 'MC', MAG_CAL);
filenames.footMagCal = generate_filename(EXERCISE, DATE, TRIAL, FOOT_SENSOR, 'MC', MAG_CAL);

filenames.distalHighg = generate_filename(EXERCISE, DATE, TRIAL, DISTAL_SENSOR, 'highg');
filenames.distalLowg = generate_filename(EXERCISE, DATE, TRIAL, DISTAL_SENSOR, 'lowg');
filenames.distalMag = generate_filename(EXERCISE, DATE, TRIAL, DISTAL_SENSOR, 'mag');