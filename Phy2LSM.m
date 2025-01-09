clc;
clear;
load('BldMap_trueHeight.mat');
%BS2Dloc=rand(1,2)*400+[200,200];%基站2D坐标在[200,600]x[200,600]
BS2Dloc=[400,400];
Bsloc_BldHeight=max([smallBldMap(ceil(BS2Dloc(1)),ceil(BS2Dloc(2))), 
                     smallBldMap(ceil(BS2Dloc(1)),floor(BS2Dloc(2))),
                     smallBldMap(floor(BS2Dloc(1)),ceil(BS2Dloc(2))), 
                     smallBldMap(floor(BS2Dloc(1)),floor(BS2Dloc(2)))]);

mesh(smallBldMap);
hold on;
%BSHeight=Bsloc_BldHeight+0.01;%基站高度取建筑物上的20m
BSHeight=Bsloc_BldHeight+0.01;
%BSHeight = 15;
BSloc=[BS2Dloc,BSHeight];
plot3(BSloc(1),BSloc(2),BSloc(3),'r*','markersize',10);
legend('Buildings','BS');
UAVheight=max(max(smallBldMap));%139m,Building最大高度129m
hold off;
%%
%获取Building的3D坐标，每个（i，j）上的建筑物上的三维坐标，高度是建筑物最大高度
[NUM_X,NUM_Y]=size(smallBldMap);
Bld_grid_3Dloc=cell(NUM_X,NUM_Y);%NUM_X x NUM_Y x3 每个网格的3D位置
UAVgrid_Bs_dist=zeros(NUM_X,NUM_Y);
for i = 1:NUM_X
    for j = 1:NUM_Y
        temp = [i,j,smallBldMap(i,j)];
        Bld_grid_3Dloc{i,j} = temp;
        temp = [i,j,UAVheight];
        UAVgrid_Bs_dist(i,j) = norm(temp-BSloc);
    end
end

Map_grid = reshape(Bld_grid_3Dloc,[NUM_X*NUM_Y,1]);
Map_grid = cell2mat(Map_grid);
Map_grid(:,3) = UAVheight;
%% 建立3D LSM, 范围[max(Build), max(Build+20)]
[NUM_X,NUM_Y]=size(smallBldMap);

% LSM = create_LSM(BSloc,smallBldMap,UAVheight);
% imagesc(LSM');
% set(gca,'YDir','normal')
% colorbar;
% title('Real LSM')

% 1m x 1m的LSM 

LSM1_real=ones(NUM_X,NUM_Y); % 可以使用str = strings(NUM_X,NUM_Y)生成LSM,但是这里用1，0表示LOS,NLOS
for i = 1:NUM_X
    disp(i)
    for j = 1:NUM_Y
        Ray_Point = Compute_Rayline(BSloc,[i,j,UAVheight]); % 计算BS和UAV高度平面上一点连线的点三维坐标
        label = (Ray_Point(:,2)-1)*NUM_X+Ray_Point(:,1);
        if label <= 0
            disp(label)
        end
        if label-fix(label) ~= 0
            disp(label)
        end
        % disp(label)
        flag = (Ray_Point(:,3) <= smallBldMap(label));
        if sum(flag) == 0 %
            LSM1_real(i,j) = 1; % 1表示los，0表示nlos
        else
            LSM1_real(i,j) = 0;
        end
    end
end
figure;
imagesc(LSM1_real');
set(gca,'YDir','normal')
colorbar;
title('Real LSM, 1m x 1m')

% 2m x 2m的LSM
LSM2_real=ones(NUM_X/2,NUM_Y/2);
for i = 1:NUM_X/2
    disp(i)
    for j = 1:NUM_Y/2
        Ray_Point = Compute_Rayline(BSloc,[i*2,j*2,UAVheight]); % 计算BS和UAV高度平面上一点连线的点三维坐标
        label = (Ray_Point(:,2)-1)*NUM_X+Ray_Point(:,1);
        if label <= 0
            disp(label)
        end
        if label-fix(label) ~= 0
            disp(label)
        end
        % disp(label)
        flag = (Ray_Point(:,3) <= smallBldMap(label));
        if sum(flag) == 0 %
            LSM2_real(i,j) = 1; % 1表示los，0表示nlos
        else
            LSM2_real(i,j) = 0;
        end
    end
end
figure;
imagesc(LSM2_real');
set(gca,'YDir','normal')
colorbar;
title('Real LSM, 2m x 2m')
% 4m x 4m的LSM
LSM4_real=ones(NUM_X/4,NUM_Y/4);
for i = 1:NUM_X/4
    disp(i)
    for j = 1:NUM_Y/4
        Ray_Point = Compute_Rayline(BSloc,[i*4,j*4,UAVheight]); % 计算BS和UAV高度平面上一点连线的点三维坐标
        label = (Ray_Point(:,2)-1)*NUM_X+Ray_Point(:,1);
        if label <= 0
            disp(label)
        end
        if label-fix(label) ~= 0
            disp(label)
        end
        % disp(label)
        flag = (Ray_Point(:,3) <= smallBldMap(label));
        if sum(flag) == 0 %
            LSM4_real(i,j) = 1; % 1表示los，0表示nlos
        else
            LSM4_real(i,j) = 0;
        end
    end
end
figure;
imagesc(LSM4_real');
set(gca,'YDir','normal')
colorbar;
title('Real LSM, 4m x 4m')

% 8m x 8m的LSM
LSM8_real=ones(NUM_X/8,NUM_Y/8);
for i = 1:NUM_X/8
    disp(i)
    for j = 1:NUM_Y/8
        Ray_Point = Compute_Rayline(BSloc,[i*8,j*8,UAVheight]); % 计算BS和UAV高度平面上一点连线的点三维坐标
        label = (Ray_Point(:,2)-1)*NUM_X+Ray_Point(:,1);
        if label <= 0
            disp(label)
        end
        if label-fix(label) ~= 0
            disp(label)
        end
        % disp(label)
        flag = (Ray_Point(:,3) <= smallBldMap(label));
        if sum(flag) == 0 %
            LSM8_real(i,j) = 1; % 1表示los，0表示nlos
        else
            LSM8_real(i,j) = 0;
        end
    end
end
figure;
imagesc(LSM8_real');
set(gca,'YDir','normal')
colorbar;
title('Real LSM, 8m x 8m')
