function outputArg1= create_LSM(Bs_Loc,Build_Map,UAV_Height)
%CREATE_LSM 此处显示有关此函数的摘要
%   此处显示详细说明
[NUM_X,NUM_Y]=size(Build_Map);
LSM_real=ones(NUM_X,NUM_Y); %可以使用str = strings(NUM_X,NUM_Y)生成LSM,但是这里用1，0表示LOS,NLOS
for i = 1:NUM_X
    disp(i)
    for j = 1:NUM_Y
        Ray_Point = Compute_Rayline(Bs_Loc,[i,j,UAV_Height]); %计算BS和UAV高度平面上一点连线的点三维坐标
        label = (Ray_Point(:,2)-1)*NUM_X+Ray_Point(:,1);
        if label <= 0
            disp(label)
        end
        if label-fix(label) ~= 0
            disp(label)
        end
        %disp(label)
        flag = (Ray_Point(:,3) <= Build_Map(label));
        if sum(flag) == 0 %
            LSM_real(i,j) = 1; %1表示los，0表示nlos
        else
            LSM_real(i,j) = 0;
        end
    end
    %disp(label)
%     disp(Ray_Point(:,2));
%     disp('a');
%     disp(Ray_Point(:,1));
end

outputArg1 = LSM_real;
end

