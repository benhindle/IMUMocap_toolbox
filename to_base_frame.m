function origin_orient_quat = to_base_frame(q_os, static_fusion)

    origin_orient_quat = quatmultiply(quatconj(q_os), compact(meanrot(static_fusion.fusion)));
    
end