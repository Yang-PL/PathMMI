function Route_planner_baseline = Route_planner_baseline
    Route_planner_baseline.Grid_planner = @Grid_planner;
    Route_planner_baseline.SquareSpiralGrid_planner = @SquareSpiralGrid_planner;
    Route_planner_baseline.Random_planner = @Random_planner;
end



function route1 = Grid_planner(map, dist_between_meas_loc) %, num_of_meas)
    [NUMX,NUMY] = size(map);
    % 初始点在左上角
    measurementPositions = [];
    start_pos = [1, 1];   % 起点 (x, y)
    step_size = dist_between_meas_loc;
   
    
    % 假设无人机按列飞行，蛇形轨迹
    current_pos = start_pos;
    isMovingDown = true;  % 控制蛇形轨迹的方向（是否向下）
    col = 1;

    % 循环遍历栅格地图，沿列飞行
    while col < NUMY
        if isMovingDown
            % 向下飞行，遍历当前列
            for row = 1:step_size:NUMX
                current_pos = [row, col];  % 更新当前位置
                measurementPositions = [measurementPositions; current_pos]; % 记录路径
                if row + step_size > NUMX
                    break;
                end
            end
        else
            % 向上飞行，遍历当前列
            for row = current_pos(1):-step_size:1
                current_pos = [row, col];  % 更新当前位置
                measurementPositions = [measurementPositions; current_pos]; % 记录路径
                if row - step_size < 1
                    break;
                end
            end
        end
        
        % 切换蛇形轨迹的方向
        isMovingDown = ~isMovingDown;
    
        % 如果不是最后一列，向右飞行到下一个列
        if col < NUMY
            % 列间的水平飞行，飞行距离与垂直步长相同
            current_pos = [current_pos(1), col + step_size]; % 记录右移位置
            col = current_pos(2);
           % measurementPositions = [measurementPositions; current_pos];  % 记录右移位置
        end
    end
        
    route1 = measurementPositions;
end



function route2 = SquareSpiralGrid_planner(map, dist_between_meas_loc)%, num_of_meas)
    [NUMX,NUMY] = size(map);
    

    % 初始化路径
    start_pos = [1,1];
    path = start_pos; 
    current_pos = start_pos;
    % 定义螺旋步长
    step_size = dist_between_meas_loc;  % 初始步长
    bound = NUMX;
    eachpath_len = 0;
    while (eachpath_len + step_size < bound) %  && (current_pos(1) + step_size <= map_height + start_pos(1)) && (current_pos(2) + step_size <= map_width + start_pos(2))
           current_pos = current_pos + step_size * [0,1]; % 更新当前位置
           eachpath_len =  eachpath_len + step_size;
           if current_pos(1) > 0 && current_pos(1) <= NUMX && current_pos(2) > 0 && current_pos(2) <= NUMY
                path = [path; current_pos];  % 记录路径
           end
            % if (current_pos(1) + step_size > map_height) || (current_pos(2) + step_size > map_width)
            %    break;
            % end
    end



    % 定义螺旋方向
    
    directions = [
                  1, 0;  % 向右
                  0, -1;  % 向下
                  -1, 0; % 向左
                  0, 1; % 向下
                       ]; 
    dir_index = 1;  % 初始方向为向右
    
    
    
    % 开始路径规划，沿着矩形螺旋轨迹
    while bound > step_size
        eachpath_len = 0;
        % 沿当前方向前进, % 确保无人机在栅格内
        while (eachpath_len + step_size < bound) %  && (current_pos(1) + step_size <= map_height + start_pos(1)) && (current_pos(2) + step_size <= map_width + start_pos(2))
           current_pos = current_pos + step_size * directions(dir_index, :); % 更新当前位置
           eachpath_len =  eachpath_len + step_size;
           if current_pos(1) > 0 && current_pos(1) <= NUMX && current_pos(2) > 0 && current_pos(2) <= NUMY
                path = [path; current_pos];  % 记录路径
           end
            % if (current_pos(1) + step_size > map_height) || (current_pos(2) + step_size > map_width)
            %    break;
            % end
        end

        
        % 更新方向
        dir_index = mod(dir_index, 4) + 1;  % 顺时针旋转方向（0->1->2->3->0）
        % count = ;

        % 每经过两次方向更新（即一圈），更新栅格"边界"大小
        if mod(dir_index, 2) == 1 
            bound = bound - step_size;
        end
        
    end

    route2 = path;
    
    
end



function route3 = Random_planner(map, dist_between_meas_loc, num_of_meas)
    [NUMX,NUMY] = size(map);
    step_size = dist_between_meas_loc;
    
    start_pos = [randi(NUMX), randi(NUMY)];
    % 初始化采样点集合
    measurementPositions = [];

    while num_of_meas > 0
        target = [randi(NUMX), randi(NUMY)];
        % 计算从 A 到 B 的向量
        vector = target - start_pos; 
        % 计算直线的长度
        distance = norm(vector); 

        % 计算沿直线方向的单位向量
        direction = vector / distance;
        
        % 从 A 开始按步长进行采样
        num_points = floor(distance / step_size); % 计算可以采样的点数
        
        for i = 0:num_points
        % 当前点的位置
            current_position = start_pos + i * step_size * direction;
            measurementPositions = [measurementPositions; current_position]; % 将当前点添加到集合中
            num_of_meas = num_of_meas - 1;
            if num_of_meas <= 0
                break;
            end
        end
        
        

         % 确保终点 target 包含在采样结果中
        if ~ismember(target, measurementPositions, 'rows')
            if num_of_meas <= 0
                break
            end
            measurementPositions = [measurementPositions; target];
            num_of_meas = num_of_meas - 1;
        end
        start_pos = target;
    end


    route3 = round(measurementPositions);
end

