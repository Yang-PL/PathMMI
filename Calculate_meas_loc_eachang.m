function maxValuePositions = Calculate_meas_loc_eachang(mapCenter,mapData,angles,Boundary)
%   mapCenter是基站的位置，mapData是互信息地图，numAngles是离散角度集合，Boundary是边界
%   此处显示详细说明

    mapSize = size(mapData);

    
    %% 计算每个角度方向上数值最大的栅格
    maxValuePositions = zeros(length(angles), 2);

    for i = 1:length(angles)
        angle = angles(i);
        
        % 计算终点坐标（取较长的延伸距离）
        maxDist = Boundary(i);  % 最大搜索半径
        endX = round(mapCenter(1) + maxDist * cos(angle));
        endY = round(mapCenter(2) + maxDist * sin(angle));
        
        Ray = Ray_line;
        % 使用 Bresenham 线算法获取沿角度的路径点
        linePoints = Ray.Bresenham(mapCenter(1), mapCenter(2), endX, endY);
        
        % 搜索路径上的最大值
        maxVal = -inf;
        bestPos = [0, 0];
        
        for j = 1:size(linePoints, 1)
            x = linePoints(j, 1);
            y = linePoints(j, 2);
            
            % 确保坐标在地图范围内
            if x > 0 && x <= mapSize(1) && y > 0 && y <= mapSize(2)
                if mapData(x, y) > maxVal
                    maxVal = mapData(x, y);
                    bestPos = [x, y];
                end
            end
        end
        
        maxValuePositions(i, :) = bestPos;
    end
end

