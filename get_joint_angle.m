function joint_angle = get_joint_angle(proximalFusion, distalFusion)
    global SEQUENCE_OF_INTEREST
    
    joint_angle.quat = quatmultiply(quatconj(compact(proximalFusion.orientQuat)), compact(distalFusion.orientQuat));
    joint_angle.seq = ["XYZ", "XZY", "XYX", "XZX", "YXZ", "YZX", "YXY", "YZY", "ZXY", "ZYX", "ZXZ", "ZYZ"];
    joint_angle.time = proximalFusion.time;
    
    int = plotSeqInterest(SEQUENCE_OF_INTEREST); 
    joint_angle.radian = quat2angle(joint_angle.quat, joint_angle.seq(int)); 
    joint_angle.degree = (joint_angle.radian*(180/pi));
    
    end