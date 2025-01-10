function P = Plos(r,BSloc)
%UNTITLED3 输入距离，返回先验LoS概率Plos
%   此处显示详细说明


% hb=15.01; %BS altitude
hb = BSloc(3); %BS altitude
hu = 129; %UAV flying altitude


phi = (asin((hu-hb)./sqrt(r.^2+(hu-hb).^2)))*180/pi;
% theta = theta*180/pi;
% % Dense Urban Parameter
% a = 187.3;
% b = 0;
% c = 0;
% d = 82.10;
% e = 0.1478;
%Urban Parameter
a = 120;
b = 0;
c = 0;
d = 24.3;
e = 1.229;
%Suburban Parameter
% a = 101.6;
% b = 0;
% c = 0;
% d = 3.25;
% e = 1.241;



P =(a-(a-b)./(1+((phi-c)/d).^e))./100; %LOS概率的先验分布。





end

