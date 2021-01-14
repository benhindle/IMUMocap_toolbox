function segment_orentation = transform_to_segment_frame(sensor_fusion, sensor_origin_orient_quat)
    global SEQUENCE_OF_INTEREST
    
    segment_orentation.orientQuat = quaternion(quatmultiply(quatnormalize(compact(sensor_fusion.fusion)), quatconj(sensor_origin_orient_quat)));
    segment_orentation.degree = eulerd(sensor_fusion.orientQuat, SEQUENCE_OF_INTEREST, 'frame');
    
    end