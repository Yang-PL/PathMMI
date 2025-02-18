function resampledPoints = resampleTrajectory(waypoints, stepLength)
    % resampleTrajectory 对给定的轨迹点（多段直线组成的路径）按固定步长进行重采样
    %
    % 输入:
    %   waypoints - 初步轨迹点，依次排列 [x, y]
    %   stepLength - 两航点之间的固定飞行距离
    %
    % 输出:
    %   resampledPoints - 重采样后的航迹点，每隔固定飞行距离一个点

    % 计算各段直线的距离和总路径长度
    segDiff = diff(waypoints, 1, 1);
    segLengths = sqrt(sum(segDiff.^2, 2));
    totalLength = sum(segLengths);
    
    % 生成沿路径的采样距离：从0到totalLength，每隔stepLength取一个点
    sampleDists = 0:stepLength:totalLength;
    if sampleDists(end) < totalLength
        sampleDists = [sampleDists, totalLength];
    end
    
    % 对每个采样距离，确定其所在的段落和在该段内的比例
    resampledPoints = zeros(length(sampleDists), 2);
    currentSegStartDist = 0;
    segIndex = 1;
    for i = 1:length(sampleDists)
        d = sampleDists(i);
        % 使d落入当前段内，如果超过当前段则移动到下一个段
        while segIndex <= length(segLengths) && d > currentSegStartDist + segLengths(segIndex)
            currentSegStartDist = currentSegStartDist + segLengths(segIndex);
            segIndex = segIndex + 1;
        end
        if segIndex > length(segLengths)
            % 如果超过最后一段，直接取终点
            resampledPoints(i,:) = waypoints(end,:);
        else
            % 当前段内的位置
            segDist = d - currentSegStartDist;
            ratio = segDist / segLengths(segIndex);
            % 线性插值获得点坐标
            resampledPoints(i,:) = waypoints(segIndex,:) + ratio * (waypoints(segIndex+1,:) - waypoints(segIndex,:));
        end
    end
end

