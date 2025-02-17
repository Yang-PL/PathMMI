function H_L_Mxn = Compute_H_L_Mxn(LSM_prior, xn, Channel_Para)
%UNTITLED2 计算在测量位置 xn 处测量获得的地图条件熵
%   分为四步，
%   1). 自身栅格的条件熵   
%   2). 栅格与基站连线间的条件熵
%   3). 栅格之后的条件熵
%   4). 其他方向的条件熵

P_llos_xn = LSM_prior(xn(1),xn(2)); % 测量位置xn处的先验概率
 % 
d = norm(xn - BSloc); % 计算到基站之间的距离
mu1 = Channel_Para(1,1) + 10.*Channel_Para(1,2).*log10(d);   % Channel_Para(1,1) + 10.*Channel_Para(1,2).*log10(x);
mu2 = Channel_Para(2,1) + 10.*Channel_Para(2,2).*log10(d);   % Channel_Para(2,1) + 10.*Channel_Para(2,2).*log10(x);
var1 =  Channel_Para(1,3);
var2 =  Channel_Para(2,3);
m = (mu1 + mu2)/2;
eps1 = 1 - qfunc((m - mu1)./sqrt(var1)); % 虚警率
eps2 = qfunc((m - mu2)./sqrt(var2)); % 误警率

P_mlos_xn =  (1 - eps1).*P_llos_xn +eps2.*(1- P_llos_xn); %p(mn = 1, los)
P_mnlos_xn =  eps1.*P_llos_xn + (1 - eps2).*(1 - P_llos_xn); %p(mn = 0, nlos)   

P_llos_xn_mlos_xn = ((1-eps1).*P_llos_xn./((1 - eps1).*P_llos_xn + eps2.*(1 - P_llos_xn))); % 条件概率P(l(xn)=los|m(xn)=los)
P_llos_xn_mnlos_xn = ((eps1.*P_llos_xn)./(eps1.*P_llos_xn + (1 - eps2).*(1 - P_llos_xn) )); % 条件概率P(l(xn)=los|m(xn)=nlos)

% 1). 自身栅格的条件熵
H_l_m_los_xn =  -(P_llos_xn_mlos_xn.*log(P_llos_xn_mlos_xn + eps)+(1 - P_llos_xn_mlos_xn).*log(1 - P_llos_xn_mlos_xn+eps));
H_l_m_nlos_xn =   -(P_llos_xn_mnlos_xn.*log(P_llos_xn_mnlos_xn + eps)+(1 - P_llos_xn_mnlos_xn).*log(1 - P_llos_xn_mnlos_xn+eps));

H_l_m_xn = P_mlos_xn.*H_l_m_los_xn + P_mnlos_xn.*H_l_m_nlos_xn;

% 2). 栅格与基站连线间的条件熵
Ray=Ray_line;
Ray1 = Ray.Bresenham(BSloc(1),BSloc(2),xn(1),xn(2)); %Ray1,BS-UAV之间的点
%去掉Rx的点，即点（xn,yn）;
index1 = find((abs(Ray1(:,1)-BSloc(1)) >= abs(xn(1)-BSloc(1))) | (abs(Ray1(:,2)-BSloc(2)) >= abs(xn(2)-BSloc(2))));
Ray1(index1,:) = [];

[NUM1,~] = size(Ray1);
H_l_m_x1 = zeros(NUM1,1);
for i = 1:NUM1 % 依次计算Ray1中每个栅格位置的互信息大小
    x1 = Ray1(i,:);
    P_llos_x1 = LSM_prior(x1(1),x1(2)); % 位置x1处的先验LoS概率

    P_llos_x1_mlos_xn = ((1 - eps1).*P_llos_xn + eps2.*(P_llos_x1 - P_llos_xn))./((1 - eps1).*P_llos_xn + eps2.*(1 - P_llos_xn));
    P_llos_x1_mnlos_xn = (eps1.*P_llos_xn + (1 - eps2).*(P_llos_x1 - P_llos_xn))./(eps1.*P_llos_xn + (1 - eps2).*(1 - P_llos_xn));

    H_l_m_los_x1 =  -(P_llos_x1_mlos_xn.*log(P_llos_x1_mlos_xn + eps)+(1 - P_llos_x1_mlos_xn).*log(1 - P_llos_x1_mlos_xn+eps));
    H_l_m_nlos_x1 =   -(P_llos_x1_mnlos_xn.*log(P_llos_x1_mnlos_xn + eps)+(1 - P_llos_x1_mnlos_xn).*log(1 - P_llos_x1_mnlos_xn+eps));

    H_l_m_x1(i) = P_mlos_xn.*H_l_m_los_x1 + P_mnlos_xn.*H_l_m_nlos_x1;

end

% 3). 栅格之后的条件熵
Map_lowBound = 1;%不能设置0以防数组索引出界
[Map_UpBound,~] = size(LSM_prior);
Ray2 = Ray.Compute_Raypoint_extension(BSloc(1),BSloc(2),xn(1),xn(2),Map_lowBound,Map_UpBound);%Ray2,BS-UAV延长线上的点
index2 = find((abs(Ray2(:,1)-BSloc(2)) <= abs(xn(2)-BSloc(2))) | (abs(Ray2(:,2)-BSloc(2)) <= abs(xn(2)-BSloc(2))));
Ray2(index2,:) = [];

[NUM2,~] = size(Ray2);
H_l_m_x2 = zeros(NUM2,1);
for i = 1:NUM2 % 依次计算Ray2中每个栅格位置的互信息大小
    x2 = Ray2(i,:);
    P_llos_x2 = LSM_prior(x2(1),x2(2)); % 位置x2处的先验LoS概率

    P_llos_x2_mlos_xn = (1 - eps1).*P_llos_x2./((1 - eps1).*P_llos_xn + eps2.* (1 - P_llos_xn)); % 
    P_llos_x2_mnlos_xn = (eps1.*P_llos_x2)./(eps1.*P_llos_xn + (1 - eps2).* (1 - P_llos_xn) ); % 

    H_l_m_los_x2 = -(P_llos_x2_mlos_xn.*log(P_llos_x2_mlos_xn + eps)+(1 - P_llos_x2_mlos_xn).*log(1 - P_llos_x2_mlos_xn+eps));
    H_l_m_nlos_x2 =   -(P_llos_x2_mnlos_xn.*log(P_llos_x2_mnlos_xn + eps)+(1 - P_llos_x2_mnlos_xn).*log(1 - P_llos_x2_mnlos_xn+eps));

    H_l_m_x2(i) = P_mlos_xn.*H_l_m_los_x2 + P_mnlos_xn.*H_l_m_nlos_x2;

end

% 4). 其他方向的条件熵
% 利用角度上的空间相关性

% 栅格位置索引 G_Index;
rows = 800; cols = 800; % 生成索引向量
% 使用 ndgrid 生成索引矩阵
[X, Y] = ndgrid(1:rows, 1:cols);
% 将索引矩阵转换为索引向量 
G_Index = [X(:), Y(:)];

R = [Ray1;Ray2];

[~, idx] = ismember(G_Index,R);

G_Index(idx ~= 0) = [];

[NUM3,~] = size(G_Index);
H_l_m_x3 = zeros(NUM3,1);

Vec_n = xn - BSloc(1:2);
phi_n = atan2(Vec_n(2),Vec_n(1));
for i = 1 : NUM3
    x3 = G_Index(i);
    P_llos_x3 = LSM_prior(x3(1),x3(2)); % 位置x3处的先验LoS概率

    Vec = x3 - BSloc(1:2);
    
    phi = atan2(Vec(2),Vec(1)); % 要计算的位置x3与测量位置xn之间相对基站的角度
    delta_phi
    rho = 1 - exp(beta*(1-pi./delta_phi)); % 相关系数：p(l(x3),l(xn));

    
    s11_x3_xn =    ; % 空间相关性 p(l_x3 = 1|l_xn = 1)
    s10_x3_xn =    ; % 空间相关性 p(l_x3 = 1|l_xn = 0)

    P_llos_x3_mlos_xn = ((1 - eps1).*s11_x3_xn.*P_llos_xn + eps2.*s10_x3_xn.*(1 - P_llos_xn))./(P_mlos_xn);
    P_llos_x3_mnlos_xn = (eps1.*s11_x3_xn.*P_llos_xn + (1 - eps2).*s10_x3_xn.*(1 - P_llos_xn))./(P_mnlos_xn);
    
    H_l_m_los_x3  = -(P_llos_x3_mlos_xn.*log(P_llos_x3_mlos_xn + eps)+(1 - P_llos_x3_mlos_xn).*log(1 - P_llos_x3_mlos_xn+eps));
    H_l_m_nlos_x3 = -(P_llos_x3_mnlos_xn.*log(P_llos_x3_mnlos_xn + eps)+(1 - P_llos_x3_mnlos_xn).*log(1 - P_llos_x3_mnlos_xn+eps));

    H_l_m_x3(i) = P_mlos_xn.*H_l_m_los_x3 + P_mnlos_xn.*H_l_m_nlos_x3;


end

H_L_Mxn = H_l_m_xn + sum(H_l_m_x1) + sum(H_l_m_x2) + sum(H_l_m_x3);


end

