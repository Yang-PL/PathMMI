function H_L_Mx = Compute_H_l_Mx(LSM_prior, x, Channel_Para)
%UNTITLED2 计算在测量位置x处测量获得的条件熵
%   分为四步，
%   1). 自身栅格的条件熵   
%   2). 栅格与基站连线间的条件熵
%   3). 栅格之后的条件熵
%   4). 其他方向的条件熵

% 1). 自身栅格的条件熵



% 2). 栅格与基站连线间的条件熵




% 3). 栅格之后的条件熵


Ray=Ray_line;
Map_lowBound = 1;%不能设置0以防数组索引出界
[Map_UpBound,~,~] = size(LSMlog_prior);
%Ray1 = Ray.Compute_Raypoint(BSloc(1),BSloc(2),xt(1),xt(2));%Ray1,BS-UAV之间的点
Ray1 = Ray.Bresenham(BSloc(1),BSloc(2),xt(1),xt(2));%Ray1,BS-UAV之间的点
%%去掉Rx的点，即点（xt,yt）;
index = find((abs(Ray1(:,1)-BSloc(1)) >= abs(xt(1)-BSloc(1))) | (abs(Ray1(:,2)-BSloc(2)) >= abs(xt(2)-BSloc(2))));
Ray1(index,:) = [];
Ray2 = Ray.Compute_Raypoint_extension(BSloc(1),BSloc(2),xt(1),xt(2),Map_lowBound,Map_UpBound);%Ray2,BS-UAV延长线上的点
index = find((abs(Ray2(:,1)-BSloc(2)) <= abs(xt(2)-BSloc(2))) | (abs(Ray2(:,2)-BSloc(2)) <= abs(xt(2)-BSloc(2))));
Ray2(index,:) = [];

Ray1(:,3) = xt(3); % 考虑同一水平面上的LSM。
Ray2(:,3) = xt(3);

[NUM1,~] = size(Ray1);
[NUM2,~] = size(Ray2);





end