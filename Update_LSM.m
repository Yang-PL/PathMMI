function [updated_grid,LSM_posterior] = Update_LSM(LSM_prior, xn, zn, Channel_Para, LSM_initial, BSloc)
%Update_LSM 用一个在xn的测量值来更新LSM
%   Detailed explanation goes here
%   Input: P_llos is the initial LoS probability, LSM_prior is the prior LoS probability.
%   Output: updated_grid is the updated grid.

% 在测量位置的方向上的栅格更新
Ray=Ray_line;
Ray1 = Ray.Bresenham(BSloc(1),BSloc(2),xn(1),xn(2)); %Ray1,BS-UAV之间的点
% 去掉Rx的点，即点（xn,yn）;
% index1 = find((abs(Ray1(:,1)-BSloc(1)) >= abs(xn(1)-BSloc(1))) | (abs(Ray1(:,2)-BSloc(2)) >= abs(xn(2)-BSloc(2))));
% Ray1(index1,:) = []; % 去掉Rx的点这块有问题。
[NUM1,~] = size(Ray1);

Map_lowBound = 1;%不能设置0以防数组索引出界
[Map_UpBound,~] = size(LSM_prior);
Ray2 = Ray.Compute_Raypoint_extension(BSloc(1),BSloc(2),xn(1),xn(2),Map_lowBound,Map_UpBound);%Ray2,BS-UAV延长线上的点
% index2 = find((abs(Ray2(:,1)-BSloc(2)) <= abs(xn(2)-BSloc(2))) | (abs(Ray2(:,2)-BSloc(2)) <= abs(xn(2)-BSloc(2))));
% Ray2(index2,:) = [];

[NUM2,~] = size(Ray2);

Inv_sensor = Inverse_sensor_model;
d = norm(xn - BSloc);

mu_g = Channel_Para(:,1)+10.*Channel_Para(:,2).*log10(d);
var_g = Channel_Para(:,3); 
var_meas = 0;


P_llos_xn = LSM_initial(xn(1),xn(2)); % 索引xn处的初始LoS概率
LSMlog_prior = log(LSM_prior./(1 - LSM_prior + eps));
LSMlog_initial = log(LSM_initial./(1 - LSM_initial + eps));

LSMlog_posterior = LSMlog_prior; % 后验概率初始化
% 该测量栅格位置的LoS地图更新
LSMlog_posterior(xn(1),xn(2)) = LSMlog_prior(xn(1),xn(2)) + Inv_sensor.pdflog_ln_zn(zn,mu_g,var_g,var_meas,P_llos_xn) - LSMlog_initial(xn(1),xn(2));
pdflog_ln_zn = Inv_sensor.pdflog_ln_zn(zn,mu_g,var_g,var_meas,P_llos_xn);
P_ln_zn = 1 - 1./(1 + exp(pdflog_ln_zn));

for i = 1:NUM1 % 1. 更新连线RAY1上的LSMlog
    P_llos_x1 = LSM_initial(Ray1(i,1),Ray1(i,2));
    LSMlog_posterior(Ray1(i,1),Ray1(i,2)) = LSMlog_prior(Ray1(i,1),Ray1(i,2)) + Inv_sensor.pdflog_l1_zn(zn,mu_g,var_g,var_meas,P_llos_xn,P_llos_x1) - LSMlog_initial(Ray1(i,1),Ray1(i,2));

end


for j = 1:NUM2 % 2. 连线延长线RAY2上的LSMlog的更新
    P_llos_x2 = LSM_initial(Ray2(j,1),Ray2(j,2));
    LSMlog_posterior(Ray2(j,1),Ray2(j,2)) = LSMlog_prior(Ray2(j,1),Ray2(j,2)) + Inv_sensor.pdflog_l2_zn(zn,mu_g,var_g,var_meas,P_llos_xn,P_llos_x2) - LSMlog_initial(Ray2(j,1),Ray2(j,2));

end

[~,idx1,~] = intersect(Ray1,Ray2,'rows'); % [common_rows,idx1,idx2] = intersect(ARRAY1,ARRAY2,'rows')
Ray1(idx1,:) = [];
updated_grid = [Ray1;Ray2];

% 
% % 3. 其他方向上的更新
% 
% % \phi_th设置为15°, pi/12。
% 
% phi_th = pi./48;
% 
% % 在一个矩形栅格中找出与中心点连线和给定点与中心点连线所成夹角小于某角度的栅格，并给出栅格的两维坐标
% % 获得矩形栅格的大小 
% grid_size = size(LSM_prior);  
% 
% % 创建一个矩形栅格 
% [x, y] = meshgrid(1:grid_size(1), 1:grid_size(2)); 
% % 计算每个点相对于基站的角度 
% angles_center = atan2(y - BSloc(2), x - BSloc(1)); 
% % 计算给定点xn相对于基站的角度 
% angle_xn = atan2(xn(2) - BSloc(2), xn(1) - BSloc(1)); 
% % 计算每个点相对于中心点和给定点A的夹角 
% angle_diff = abs(angles_center - angle_xn); 
% % 找出夹角小于指定角度阈值的点 
% mask = angle_diff <= phi_th; 
% % 获取符合条件的点的二维坐标 
% [row, col] = find(mask); 
% Ray3 = [col,row]; % 要更新的栅格坐标
% updated_grid = [col,row];
% 
% [~,idx1,~] = intersect(Ray3,Ray1,'rows');
% Ray3(idx1,:) = [];
% [~,idx2,~] = intersect(Ray3,Ray2,'rows');
% Ray3(idx2,:) = [];
% 
% [NUM3,~] = size(Ray3);
% 
% beta = 1;
% 
% [~,idx1,~] = intersect(Ray1,Ray2,'rows'); % [common_rows,idx1,idx2] = intersect(ARRAY1,ARRAY2,'rows')
% Ray1(idx1,:) = [];
% Ray12 = [Ray1;Ray2];
% 
% 
% for k = 1:NUM3    
%     P_llos_x3 = LSM_initial(Ray3(k,1),Ray3(k,2));
%     d_temp = norm(Ray3(k,:) - BSloc(1:2));
%     vec = vecnorm(Ray12 - BSloc(1:2),2,2);
%     [~,idx] = min(abs(vec - d_temp));
%     xs3 = Ray12(idx,:);
%     P_ln_znxs3 = 1 - 1./(1 + exp(LSMlog_posterior(xs3(1),xs3(2)))); % Ray1,Ray2中找与x3到基站距离最接近的栅格。
%    % Pr(l(x) = 1|zn) = Pr(l(xn) = 1|zn)s11(x, xn) + (1 − Pr(l(xn) = 1|zn))s10(x, xn).
%    % sij (x, xn) = Pr(l(x) = i|l(xn) = j)
%     
%     % 计算与测量点xn的夹角
%     vec1 = Ray3(k,:) - BSloc(1:2);
%     vec2 = xn(1:2) - BSloc(1:2);
%     delta_phi = acos(dot(vec1, vec2) / (norm(vec1)*norm(vec2)));
% 
%     rho = 1 - exp(beta*(1-pi./delta_phi));
%     s11 = P_llos_x3 + rho * (1 - P_llos_x3); % LoS先验模型是全向，到基站相同距离，不同方向是相等的
%     s10 = P_llos_x3 - rho * P_llos_x3;
%     P_l3_zn = P_ln_znxs3 * s11 + (1 - P_ln_znxs3) * s10;
%     pdflog_l3_zn = log(P_l3_zn ./(1 - P_l3_zn + eps));
%     
%     LSMlog_posterior(Ray3(k,1),Ray3(k,2)) = LSMlog_prior(Ray3(k,1),Ray3(k,2)) + pdflog_l3_zn - LSMlog_initial(Ray3(k,1),Ray3(k,2));
% end



LSM_posterior = 1 - 1./(1 + exp(LSMlog_posterior));


end

