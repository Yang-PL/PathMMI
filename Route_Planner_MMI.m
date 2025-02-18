function [measurementPositions,resampledWaypoints] = Route_Planner_MMI(I_Lphi_Mxn, startPos, destPos, LSM, BSloc)
%ROUTE_PLANNER_MMI 此处显示有关此函数的摘要
%   起点startPos和终点destPos


    %% 生成均匀间隔的角度集合
    numAngles = 18;  % 设定角度数量（如每20度一个，共36个）
    angles = linspace(0, 2*pi, numAngles + 1);  
    angles(end) = [];  % 去掉2*pi，避免重复
    
    Boundary = zeros(numAngles,1);
    for i = 1:numAngles
        [Boundary(i), ~] = Find_Boundary(angles(i),LSM,BSloc);
    end

    
    
    measurementPositions = Calculate_meas_loc_eachang(BSloc(1:2),I_Lphi_Mxn,angles,Boundary);
    
    
    
    stepLength = 20;  % 固定飞行间隔，适应400范围
    
    % 生成均匀间隔的航迹点
    resampledWaypoints = generateUniformTrajectory(BSloc(1:2), startPos, destPos, measurementPositions, stepLength);






end

