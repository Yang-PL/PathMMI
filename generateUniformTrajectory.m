function [waypoints,resampledWaypoints] = generateUniformTrajectory(mapCenter, startPos, destPos, measurementPositions, stepLength)
    % generateUniformTrajectory 生成无人机从起点到终点的飞行轨迹
    % 其中初始轨迹点是从输入的离散测量点中选取（选择跨度较小的一侧）
    % 最后沿轨迹按照固定飞行长度进行重采样
    %
    % 输入:
    %   mapCenter           - 地图中心坐标 [x, y]
    %   startPos            - 起点坐标 [x, y]
    %   destPos             - 终点坐标 [x, y]
    %   measurementPositions- 离散测量位置矩阵，每行为 [x, y]
    %   stepLength          - 固定飞行长度（两航点之间的间隔）
    %
    % 输出:
    %   resampledWaypoints  - 重采样后的轨迹点（每隔固定飞行长度）

    % 第一步：从离散测量位置中构造初步轨迹（同之前的方法）
    waypoints = generateTrajectoryFromDiscrete(mapCenter, startPos, destPos, measurementPositions);
    
    % 第二步：沿初始轨迹进行重采样，得到固定间距的航迹点
    resampledWaypoints = resampleTrajectory(waypoints, stepLength);
end
