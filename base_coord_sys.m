function q_os = base_coord_sys(baseStaticFusion)
baseStaticFusion.dcm = quat2dcm(compact(meanrot(baseStaticFusion.fusion)));

meanBaseStaticAccArray = mean(baseStaticFusion.accArray);
meanBaseStaticAccArrayNorm = meanBaseStaticAccArray/norm(meanBaseStaticAccArray);

baseMeanStaticMagnetic = mean(baseStaticFusion.magArrayCorrected);
baseMeanStaticMagneticNorm = baseMeanStaticMagnetic/norm(baseMeanStaticMagnetic);

% set x, y, z axes of base sensor orientation in global frame (use as check
% for construction of q_FQA 
zAxis = meanBaseStaticAccArrayNorm;
yAxis = cross(meanBaseStaticAccArrayNorm, baseMeanStaticMagneticNorm);
yAxis = yAxis/norm(yAxis);
xAxis = cross(yAxis, zAxis);
xAxis = xAxis/norm(xAxis);

% Correct original orientation to give z axis vertical, y axis med/lateral
% and x axis ant/post direction (from backward direction of base sensor).
baseOrientZ = [0, 0, 1]; %strictly vertical z-axis
baseOrientY = cross(baseOrientZ, baseStaticFusion.dcm(1,:)); %perp. to x-axis (backward) of original orient
baseOrientY = baseOrientY/norm(baseOrientY);
baseOrientX = cross(baseOrientZ, baseOrientY);
baseOrientX = baseOrientX/norm(baseOrientX);

% Establish original orientation of segment in global coord (q_os)
dcm_os = [baseOrientX; baseOrientY; baseOrientZ];
det(dcm_os);

% Satisfy right-hand rule convention requried by Matlab dcm2quat function
% if det(dcm_os) == -1 %non-tolerance condition

if abs(det(dcm_os)--1) < 1e15*eps(min(abs(det(dcm_os)),abs(-1))) %tolerance condition - return difference 0.11
    dcm_os = [-baseOrientX; baseOrientY; baseOrientZ];
    det(dcm_os);
end 
    
q_os = dcm2quat(dcm_os);

end