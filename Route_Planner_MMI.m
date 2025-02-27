function [waypoints,resampledWaypoints] = Route_Planner_MMI(I_Lphi_Mxn, startPos, destPos, BSloc, numAngles, stepLength)
%ROUTE_PLANNER_MMI 此处显示有关此函数的摘要
%   起点startPos和终点destPos

    centerAngle = atan2(startPos(2) - BSloc(2), startPos(1) - BSloc(1));  

    %% 生成均匀间隔的角度集合
   % numAngles = 36;  % 设定角度数量（如每20度一个，共36个）
    angles = linspace(centerAngle, centerAngle+2*pi, numAngles + 1);  
    angles(end) = [];  % 去掉2*pi，避免重复
    
    Boundary = zeros(numAngles,1);
    for i = 1:numAngles
        Boundary(i) = Find_Boundary(mod(angles(i),2*pi));
    end

    
    
    measurementPositions = Calculate_meas_loc_eachang(BSloc(1:2),I_Lphi_Mxn,angles,Boundary);
    measurementPositions(1,:) = [];
    
    
    % stepLength: 固定飞行间隔，适应400范围
    
    % 生成均匀间隔的航迹点
    [waypoints,resampledWaypoints] = generateUniformTrajectory(BSloc(1:2), startPos, destPos, measurementPositions, stepLength);






end

