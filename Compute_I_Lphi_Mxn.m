function I_Lphi_Mxn = Compute_I_Lphi_Mxn(LSM_prior, xn, Channel_Para, BSloc)
%UNTITLED2 计算在测量位置 xn 处测量获得的测量方向上的互信息
%   分为四步，
%   1). 自身栅格的互信息
%   2). 栅格与基站连线间的互信息
%   3). 栅格之后的互信息

P_llos_xn = LSM_prior(xn(1),xn(2)); % 测量位置xn处的先验概率
H_l_xn = -(P_llos_xn.*log(P_llos_xn + eps) + (1 - P_llos_xn).*log(1 - P_llos_xn + eps));

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

% 1). 自身栅格的互信息
H_l_m_los_xn =  -(P_llos_xn_mlos_xn.*log(P_llos_xn_mlos_xn + eps)+(1 - P_llos_xn_mlos_xn).*log(1 - P_llos_xn_mlos_xn+eps));
H_l_m_nlos_xn =   -(P_llos_xn_mnlos_xn.*log(P_llos_xn_mnlos_xn + eps)+(1 - P_llos_xn_mnlos_xn).*log(1 - P_llos_xn_mnlos_xn+eps));

H_l_m_xn = P_mlos_xn.*H_l_m_los_xn + P_mnlos_xn.*H_l_m_nlos_xn;
I_l_m_xn = H_l_xn - H_l_m_xn;

% 2). 栅格与基站连线间的互信息
Ray=Ray_line;
Ray1 = Ray.Bresenham(BSloc(1),BSloc(2),xn(1),xn(2)); %Ray1,BS-UAV之间的点
% Ray1 = Ray.Compute_Raypoint(BSloc(1),BSloc(2),xn(1),xn(2)); %Ray1,BS-UAV之间的点
%去掉Rx的点，即点（xn,yn）;
% index1 = find((abs(Ray1(:,1)-BSloc(1)) >= abs(xn(1)-BSloc(1))) | (abs(Ray1(:,2)-BSloc(2)) >= abs(xn(2)-BSloc(2))));
% Ray1(index1,:) = []; % 去掉Rx的点这块有问题。

[NUM1,~] = size(Ray1);
H_l_m_x1 = zeros(NUM1,1);
H_l_x1 = zeros(NUM1,1);
I_l_m_x1 = zeros(NUM1,1);
for i = 1:NUM1 % 依次计算Ray1中每个栅格位置的互信息大小
    x1 = Ray1(i,:);
    P_llos_x1 = LSM_prior(x1(1),x1(2)); % 位置x1处的先验LoS概率
    H_l_x1(i) = -(P_llos_x1.*log(P_llos_x1 + eps) + (1 - P_llos_x1).*log(1 - P_llos_x1 + eps));

    P_llos_x1_mlos_xn = ((1 - eps1).*P_llos_xn + eps2.*(P_llos_x1 - P_llos_xn))./((1 - eps1).*P_llos_xn + eps2.*(1 - P_llos_xn));
    P_llos_x1_mnlos_xn = (eps1.*P_llos_xn + (1 - eps2).*(P_llos_x1 - P_llos_xn))./(eps1.*P_llos_xn + (1 - eps2).*(1 - P_llos_xn));

    H_l_m_los_x1 =  -(P_llos_x1_mlos_xn.*log(P_llos_x1_mlos_xn + eps)+(1 - P_llos_x1_mlos_xn).*log(1 - P_llos_x1_mlos_xn+eps));
    H_l_m_nlos_x1 =   -(P_llos_x1_mnlos_xn.*log(P_llos_x1_mnlos_xn + eps)+(1 - P_llos_x1_mnlos_xn).*log(1 - P_llos_x1_mnlos_xn+eps));

    H_l_m_x1(i) = P_mlos_xn.*H_l_m_los_x1 + P_mnlos_xn.*H_l_m_nlos_x1;
    
    I_l_m_x1(i) = H_l_x1(i) - H_l_m_x1(i);
end

% 3). 栅格之后的互信息
Map_lowBound = 1;%不能设置0以防数组索引出界
[Map_UpBound,~] = size(LSM_prior);
Ray2 = Ray.Compute_Raypoint_extension(BSloc(1),BSloc(2),xn(1),xn(2),Map_lowBound,Map_UpBound);%Ray2,BS-UAV延长线上的点
% index2 = find((abs(Ray2(:,1)-BSloc(2)) <= abs(xn(2)-BSloc(2))) | (abs(Ray2(:,2)-BSloc(2)) <= abs(xn(2)-BSloc(2))));
% Ray2(index2,:) = [];

[NUM2,~] = size(Ray2);
H_l_m_x2 = zeros(NUM2,1);
H_l_x2 = zeros(NUM2,1);
I_l_m_x2 = zeros(NUM2,1);
for i = 1:NUM2 % 依次计算Ray2中每个栅格位置的互信息大小
    x2 = Ray2(i,:);
    P_llos_x2 = LSM_prior(x2(1),x2(2)); % 位置x2处的先验LoS概率
    H_l_x2(i) = -(P_llos_x2.*log(P_llos_x2 + eps) + (1 - P_llos_x2).*log(1 - P_llos_x2 + eps));

    P_llos_x2_mlos_xn = (1 - eps1).*P_llos_x2./((1 - eps1).*P_llos_xn + eps2.* (1 - P_llos_xn)); % 
    P_llos_x2_mnlos_xn = (eps1.*P_llos_x2)./(eps1.*P_llos_xn + (1 - eps2).* (1 - P_llos_xn) ); % 

    H_l_m_los_x2 = -(P_llos_x2_mlos_xn.*log(P_llos_x2_mlos_xn + eps)+(1 - P_llos_x2_mlos_xn).*log(1 - P_llos_x2_mlos_xn+eps));
    H_l_m_nlos_x2 =   -(P_llos_x2_mnlos_xn.*log(P_llos_x2_mnlos_xn + eps)+(1 - P_llos_x2_mnlos_xn).*log(1 - P_llos_x2_mnlos_xn+eps));

    H_l_m_x2(i) = P_mlos_xn.*H_l_m_los_x2 + P_mnlos_xn.*H_l_m_nlos_x2;
    
    I_l_m_x2(i) = H_l_x2(i) - H_l_m_x2(i);
end

I_Lphi_Mxn = I_l_m_xn + sum(I_l_m_x1) + sum(I_l_m_x2);


end

