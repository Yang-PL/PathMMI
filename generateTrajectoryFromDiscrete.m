function waypoints = generateTrajectoryFromDiscrete(mapCenter, startPos, destPos, measurementPositions)
    % 根据地图中心、起点、终点和离散测量点构造初步飞行轨迹，
    % 如果选定方向（跨度较小的一侧）没有测量点，则采用起点与终点的直线连接。
    
    % 计算起点和终点相对于地图中心的角度（单位: 度）
    thetaStart = mod(rad2deg(atan2(startPos(2)-mapCenter(2), startPos(1)-mapCenter(1))), 360);
    thetaDest  = mod(rad2deg(atan2(destPos(2)-mapCenter(2), destPos(1)-mapCenter(1))), 360);
    
    % 计算所有离散测量位置相对于地图中心的角度
    numMeas = size(measurementPositions, 1);
    measAngles = zeros(numMeas, 1);
    for i = 1:numMeas
        measAngles(i) = mod(rad2deg(atan2(measurementPositions(i,2)-mapCenter(2), ...
                                            measurementPositions(i,1)-mapCenter(1))), 360);
    end
    
    % 将测量点和角度组合
    measData = [measurementPositions, measAngles];
    % 按角度从小到大排序
    % measData = sortrows(measData, 3);
    
    % 判断起点到终点角度跨度（顺时针和逆时针）
    if thetaDest >= thetaStart
        spanCW = thetaDest - thetaStart;
    else
        spanCW = (360 - thetaStart) + thetaDest;
    end
    spanCCW = 360 - spanCW;
    
    % 先尝试选择跨度较小的一侧
    if spanCW <= spanCCW
        % 顺时针方向：选取角度在 [thetaStart, thetaDest]（注意跨0°时特殊处理）
        if thetaDest >= thetaStart
            idx = (measData(:,3) >= thetaStart) & (measData(:,3) <= thetaDest);
        else
            idx = (measData(:,3) >= thetaStart) | (measData(:,3) <= thetaDest);
        end
        selectedDirection = 'CW';
    else
        % 逆时针方向：调整角度后进行比较
        thetaStartAdj = thetaStart;
        thetaDestAdj  = thetaDest;
        if thetaDest > thetaStart
            thetaDestAdj = thetaDest - 360;
        end
        measAnglesAdj = measData(:,3);
        measAnglesAdj(measData(:,3) > thetaStart) = measData(measData(:,3) > thetaStart, 3) - 360;
        idx = (measAnglesAdj <= thetaStartAdj) & (measAnglesAdj >= thetaDestAdj);
        selectedDirection = 'CCW';
    end
    
    selectedPoints = measData(idx, 1:2);
    selectedAngles = measData(idx, 3);
    
    % 如果选定方向没有测量点（跨度较小的一侧），则采用起点和终点直接连接。
    if isempty(selectedPoints)
        warning('选定方向没有测量点（跨度较小的一侧），采用起点与终点直接连接。');
        waypoints = [startPos; destPos];
        return;
    end
%     % 如果选定方向没有测量点，则尝试另一侧
%     if isempty(selectedPoints)
%         warning(['选定方向（',selectedDirection,'] 无测量点，尝试另一侧']);
%         if strcmp(selectedDirection, 'CW')
%             % 尝试逆时针
%             thetaStartAdj = thetaStart;
%             thetaDestAdj  = thetaDest;
%             if thetaDest > thetaStart
%                 thetaDestAdj = thetaDest - 360;
%             end
%             measAnglesAdj = measData(:,3);
%             measAnglesAdj(measData(:,3) > thetaStart) = measData(measData(:,3) > thetaStart, 3) - 360;
%             idx = (measAnglesAdj <= thetaStartAdj) & (measAnglesAdj >= thetaDestAdj);
%         else
%             % 尝试顺时针
%             if thetaDest >= thetaStart
%                 idx = (measData(:,3) >= thetaStart) & (measData(:,3) <= thetaDest);
%             else
%                 idx = (measData(:,3) >= thetaStart) | (measData(:,3) <= thetaDest);
%             end
%         end
%         selectedPoints = measData(idx, 1:2);
%         selectedAngles = measData(idx, 3);
%     end
%     
%     % 如果两侧都没有测量点，则采用起点和终点直接连接
%     if isempty(selectedPoints)
%         warning('两侧均无测量点，采用起点与终点直接连接。');
%         waypoints = [startPos; destPos];
%         return;
%     end
    
    
    % 对选取的点进行排序（依据所选方向）
    if spanCW <= spanCCW
        [~, sortIdx] = sort(mod(selectedAngles - thetaStart,360));
        selectedPoints = selectedPoints(sortIdx, :);
    else
        [~, sortIdx] = sort(mod(selectedAngles - thetaStart,360), 'descend');
        selectedPoints = selectedPoints(sortIdx, :);
    end
    
    % 构造最终轨迹：起点 -> 选中的测量点 -> 终点
    waypoints = [startPos; selectedPoints; destPos];
end

