function Dis = Find_Boundary(theta)%,LSM,BSloc)%,Loc]
%FIND_BOUNDARY 找到某个方向上LSM的边界
%    二分搜索寻找边界,返回边界到基站的距离
% LSM是1x1m分辨率的地图,因此Boundary也只能在1m的分辨率往下

if  (theta > 7/4*pi) || (theta < pi/4) || (theta > 3/4*pi && theta < 5/4*pi)
    Dis = 400./abs(cos(theta));  %地图内该方向到基站的最大距离
else
    Dis = 400./abs(sin(theta));
end

% Boundary_Dis = 1;
% 
% % 根据最大距离Dis二分搜索LSM的边界。
% x = BSloc(1) + Dis*cos(theta);
% y = BSloc(2) + Dis*sin(theta);
% x1 = floor(x).*(x > 0) + 1.*(x < 0.01);
% y1 = floor(y).*(y > 0) + 1.*(y < 0.01);
% x2 = floor(x).*(x > 0) + 1.*(x < 0.01);
% y2 = ceil(y).*(y > 0) + 1.*(y < 0.01);
% x3 = ceil(x).*(x > 0) + 1.*(x < 0.01);
% y3 = floor(y).*(y > 0) + 1.*(y < 0.01);
% x4 = ceil(x).*(x > 0) + 1.*(x < 0.01);
% y4 = ceil(y).*(y > 0) + 1.*(y < 0.01);
% flag = zeros(4,1);
% flag(1) = LSM(x1,y1);
% flag(2) = LSM(x2,y2);
% flag(3) = LSM(x3,y3);
% flag(4) = LSM(x4,y4);
% if sum(flag) > 0 % 区域中最远的位置也是LoS
%     Boundary_Dis = Dis;
%     Loc = [x,y];
% end
% 
% D2 = Dis;
% D1 = 0;
% X3 = BSloc(1);
% Y3 = BSloc(2);
% while Boundary_Dis < Dis
%     D3 = (D1+D2)./2; 
% 
%   %  D = D./2;
%     x = X3 + D3*cos(theta);
%     y = Y3 + D3*sin(theta);
%    % flag = zeros(4,1);
%     x1 = floor(x).*(x > 0) + 1.*(x < 0.01);
%     y1 = floor(y).*(x > 0) + 1.*(y < 0.01);
%     x2 = floor(x).*(x > 0) + 1.*(x < 0.01);
%     y2 = ceil(y).*(x > 0) + 1.*(y < 0.01);
%     x3 = ceil(x).*(x > 0) + 1.*(x < 0.01);
%     y3 = floor(y).*(x > 0) + 1.*(y < 0.01);
%     x4 = ceil(x).*(x > 0) + 1.*(x < 0.01);
%     y4 = ceil(y).*(x > 0) + 1.*(y < 0.01);
%     flag(1) = LSM(x1,y1);
%     flag(2) = LSM(x2,y2);
%     flag(3) = LSM(x3,y3);
%     flag(4) = LSM(x4,y4);
%     if sum(flag) == 4 %D3在LoS区域中
%         D1 = D3;
% %         X3 = x;
% %         Y3 = y;
%     elseif sum(flag) == 0 %D3在NLoS区域中
%         D2 = D3;
%     else %D3是LoS/NLoS边界
%         Boundary_Dis = D3;
%         Loc = [x,y];
%         break
%     end
% 
% end

%deltad = ;
% imagesc(LSM')
% set(gca,'YDir','normal')
% colorbar;
% title('Real LSM')

end

