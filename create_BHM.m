function building_heights = create_BHM(MAXHeight)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明


ALPHA = 0.3;
BETA = 144;
GAMA = 50;
% UAVheight = 129;
%MAXHeight = UAVheight;

% =========================================
% == Simulate the building locations and building size. Each building is modeled by a square
% D = 1; %in m, consider the area of DxD m^2
NUMX = 800; %in m, consider the area of NUMX x NUMY m^2
NUMY = 800;

% N=BETA*(D^2); % the total number of buildings
% A=ALPHA*(D^2)/N; % the expected size of each building



% 定义地图尺寸
map_size = 800;

% 定义建筑物高度地图
building_heights = zeros(map_size);

% 定义规则建筑物参数
num_buildings = 110;%floor(BETA*((NUMX/1000)^2));%50; % 建筑物数量
%Side = ALPHA*((NUMX/1000)^2)/num_buildings;%40; % 建筑物大小
building_size = 40; % sqrt(Side)*1000;
building_area = [50, 750]; % 建筑物区域
building_spacing = 30; % 建筑物间隔

% 计算建筑物位置的间隔
num_per_row = floor((building_area(2) - building_area(1)) / (building_size + building_spacing));

% 生成规则形状建筑物
for i = 1:num_buildings
    % 计算建筑物在当前行的索引
    row_index = mod(i - 1, num_per_row) + 1;
    % 计算建筑物在当前列的索引
    col_index = floor((i - 1) / num_per_row) + 1;
    
    % 计算建筑物的位置
    x = building_area(1) + (row_index - 1) * (building_size + building_spacing);
    y = building_area(1) + (col_index - 1) * (building_size + building_spacing);
    

    % 从瑞利分布中随机生成建筑物的高度
    scale_param = 50; % 瑞利分布的尺度参数
    height = raylrnd(scale_param);
    height = min(height,MAXHeight);

    % 将建筑物高度添加到地图上
    building_heights(x:x+building_size-1, y:y+building_size-1) = height;
end

% % 显示建筑物高度地图
% imagesc(building_heights);
% colormap(jet);
% colorbar;
% title('City Area Building Heights Map');
% xlabel('X');
% ylabel('Y');
% hold on;
% scatter(400,400);





end





