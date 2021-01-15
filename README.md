# IMUMocap_toolbox

IMUMocap_toolbox is a matlab-based toolbox used to measure joint kinematics and spatiotemporal parameters during human movement.

<br/><br/>

## Additional required Matlab toolboxes
----
Please note, the following Matlab toolboxes are dependencies of the IMUMocap_toolbox:
* Sensor Fusion and Tracking Toolbox
* Aerospace Toolbox

While the IMUMocap_toolbox is hevily reliant on the Sensor Fusion and Tracking Toolbox and is strongly recommended, alternate toolboxes may be used in place of the Aerospace Toolbox for quaternion math.

<br/><br/>


## Data file naming convention
----
The toolbox has been tested using IMeasureU BlueTrident IMU sensors with accelerometer, gyroscope and magnetometer data sapled at ~1125Hz, 1124Hz and 114Hz, respectively. Raw data files are logged using the Vicon Capture.U mobile device application and named in accordance with the following convention:
* Session name: date (i.e. "200115" for 15th Jan 2020) 
* Trial name: iterative trial number convention (i.e. "T01", "T02" ....). 

Magnetic calibrations are named as MC_sensorLastTwoDigits (i.e. "MC14" for sensor 1214).

The python script "rename.py" is then run to bulk rename the raw data files (as named in accordance with the above inputs within the Capture.U application) for handling in the IMUMocap_toolbox.

Place all raw data within the main.m file directory under "data/EXERCISE" where "EXERCISE" can take on any name defined according to the allocated variable.

<br/><br/>

## Data collection procedure
----
The following procedure must be adhered to for accurate spatiotemporal and kinematic measures:
* Start data collection through the Capture.U application.
* Once all sensors are initialized, instruct the participant to jump, ensuring relatively high impact with the ground. This ensures synchronization is recognised by the toolbox.
* Once landed and still, ask the participant to remain in the anatomical position with feet shoulder-width apart and feet pointing in an anterior/posterior direction for 10-15 seconds. This still position becomes the zero-reference calibration for the trial.
* The participant is then free to perform the required movement.
* A magnetic calibration must be undertaken at the conclusion of the senssion. This calibration involves rotating each device around randomly around each of the three axes for approximately one minute. Record separate calibrations for each sensor, one sensor at a time.

<br/><br/>

## Using the toolkit in a main.m script structure
----
All commands should be run from "main.m" script. Suggested variable names are provided in the "example_setup_main.m" file. 

Once variable names have been initialized as per "example_setup_main.m", the following procedure is recommended for both kinematic and spatiotemporal analysis:
1. Initialize a "filenames" object by generating file names for each proximal (kinematic only), distal (kinematic only) and base sensor and for the low/highg, mag sensors using the "generate_filename()" function. (i.e."filenames.distalLowg = generate_filename(EXERCISE, DATE, TRIAL, DISTAL_SENSOR, 'lowg');")
2. Create a data object containing all data from the specified filenames using the "data_object()" function".
3. Perform synchronization of data using the "sync_all()" function.
4. Set the original orientation of the base sensor in the global frame by passing lowg, mag parameters to the "orientation_glob()" function.
5. Establish the original base coordinate system (qos) by passing the result of step 4 to the "base_coord_sys()" function.
    
The following should be performed for each sensor used within the analysis:

6. Establish the orientation of the sensor throughout static calibration portion of the trial in the global coordinate system using function "orientation_glob()" by passing the sensor specific data of the data object created in 2.
7. Get the transformation of the sensor in the global frame to the base sensor frame using function "to_base_frame()", passing q_os and the result of 6.
8. Repeat 6 for the entire trail.
10. Using the "transform_to_segment_frame()" function, get the orientation of the segment throughout the entire trial.

For kinematic analysis:

11. Create a joint angle object using the "get_joint_angle()" function.
12. Plot and interpret data using preferred Matlab commands.

For spatiotemporal analysis:

11. Using the "get_foot_fusion()" function, get the fusion object containing the orientation/acceleration/angular rate of the foot sensor in the segment frame and the initialized event object.
12. Identify initial contact and final contact events throughout the duration of the trial using the "gait_event()" function.
13. Input the identified gait events (13) to "estimate_stride()", inturn implementing a zero-velocity update to estimate the stride length parameter.

<br/><br/>

## Functions
----

### generate_filename() -> _returns type string_
```
generate_filename(exercise, date, trial, sensor_location, sensor_suffix, mag_cal_iteration)
```
Parameter | Type | Description
| :--- | :--- | :---
exercise  | String | Name of folder within Data where raw data is located
date  | String | Session name (recommended as per date)
trial  | String | Trial name (recommended "T01" etc.)
sensor_location  | String | Sensor name (recommended last four digits of sensor)
data_type  | String | Data type (Either "highg", "lowg" or "mag")
mag_cal_iteration | String | Only used if multiple magnetic calibrations for the same sensor were used (must be defined in initialization)

<br/><br/>

### data_object() -> _returns type object_
  ```
data_object(filenames)
  ```
Parameter | Type | Description
| :--- | :--- | :---
filenames  | Object | Object containing the names of each data file from each sensor

<br/><br/>

### sync_all() -> _returns type object_
  ```
sync_all(data)
  ```
Parameter | Type | Description
| :--- | :--- | :---
data  | Object | Object containing the synced data of all sensors used within the trial

<br/><br/>

### orientation_glob() -> _returns type object_
  ```
orientation_glob(data_lowg, data_mag, mag_cal_filename, calibration_start, calibration_end, sensor_description)
  ```
Parameter | Type | Description
| :--- | :--- | :---
data_lowg  | Array | Array containing time (col 1), acceleration (col 2-4) and angular rate (col 5-7) data
data_mag  | Array | Array containing magnetic field data (col 1-3)
mag_cal_filename  | String | File name of the magnetic calibration for the selected sensor
calibration_start  | Integer | Start frame of calibration
calibration_end  | Integer | End frame of calibration
sensor_description  | String | Chose from "proximal", "distal", "base" or "foot" - can be used to set tuning parameters. By default, all parameters are the same but can be changed within the function depending on tuning requirements.

<br/><br/>

### base_coord_sys() -> _returns type quaternion_
  ```
base_coord_sys(baseStaticFusion)
  ```
Parameter | Type | Description
| :--- | :--- | :---
baseStaticFusion  | Object | Object result of orientation_glob() for base sensor

<br/><br/>

### to_base_frame() -> _returns type quaternion_
  ```
to_base_frame(q_os, static_fusion)
  ```
Parameter | Type | Description
| :--- | :--- | :---
q_os  | Quaternion | Quaternion orientation of the base sensor in the global frame
static_fusion  | Object | Orientation object produced by orientation_glob() for the static calibration portion of the trial of a given sensor

<br/><br/>

### transform_to_segment_frame() -> _returns type object
  ```
transform_to_segment_frame(sensor_fusion, sensor_origin_orient_quat)
  ```
Parameter | Type | Description
| :--- | :--- | :---
sensor_fusion  | Object | Object created using orientation_glob() for the entire trial of a given sensor
sensor_origin_orient_quat  | Object | Quaternion result of to_base_frame() establishing original orientation during static calibration of a given sensor

<br/><br/>

### get_joint_angle() -> _returns type object_
  ```
get_joint_angle(proximal_fusion, distal_fusion)
  ```
Parameter | Type | Description
| :--- | :--- | :---
proximal_fusion  | Object | Transformed object resulting from transform_to_segment_frame() for proximal sensor
distal_fusion  | Object | Transformed object resulting from transform_to_segment_frame() for distal sensor

<br/><br/>

### get_foot_fusion() -> _returns type object_
  ```
get_foot_fusion(q_os, data, foot_magcal_filename)
  ```
Parameter | Type | Description
| :--- | :--- | :---
q_os  | Quaternion | Quaternion orientation of the base sensor in the global frame
data  | Object | Object containing the synced data of all sensors used within the trial
foot_magcal_filename | String | File name of the magnetic calibration for the foot sensor

<br/><br/>

### gait_event() -> _returns type object_
  ```
gait_event(foot_fusion, start_time, end_time)
  ```
Parameter | Type | Description
| :--- | :--- | :---
foot_fusion  | Object | Result of get_foot_fusion(). Object containing orientation (degree and quaternion) and acceleration/angular rate measures
start_time  | Double | Timestamp just prior to initial step (sec)
end_time | Double | Timestamp just after final step (sec)

_NOTE: Within this function exists parameters which must be tuned for a given trial otherwise an error will likely be returned. Best practice is to include plots thoughout the function to visualise output and set parameters accordingly. Parameters are listed at the top within the function._

<br/><br/>

### estimate_stride() -> _returns type object_
  ```
estimate_stride(foot_fusion, q_os, event)
  ```
Parameter | Type | Description
| :--- | :--- | :---
foot_fusion  | Object | Result of get_foot_fusion(). Object containing orientation (degree and quaternion) and acceleration/angular rate measures
q_os  | Quaternion | Quaternion orientation of the base sensor in the global frame
event | Object | Event object created by gait_event() containing an array of initial contact and final contact instances

<br/><br/>

### get_spatiotemp() -> _returns print to consle_
  ```
get_spatiotemp(foot_fusion, event, start_plant, end_plant)
  ```
Parameter | Type | Description
| :--- | :--- | :---
foot_fusion  | Object | Result of get_foot_fusion(). Object containing orientation (degree and quaternion) and acceleration/angular rate measures
event | Object | Event object created by gait_event() containing an array of initial contact and final contact instances
initial_stance | Integer | Initial stance phase in analysis
end_stance | Integer | Final stance phase in analysis

<br/><br/>


## Additional reading
----
The toolbox has been developed based on the methods used in the article of Hindle et. al. For further details refer to the link below.

https://www.mdpi.com/1424-8220/20/16/4586#cite