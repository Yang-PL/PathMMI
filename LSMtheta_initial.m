function LSM_initial = LSMtheta_initial(UAVgrid_Bs_dist,UAVheight,BSheight)
%LSM先验概率 与俯仰角有关 refer to Elevation Dependent Shadowing Model for Mobile
%Communications via High Altitude Platforms in
%Built-Up Areas
%   此处显示详细说明

theta = asin((UAVheight-BSheight)./UAVgrid_Bs_dist);
theta = theta*180/pi;
%Dense Urban Parameter
% a = 187.3;
% b = 0;
% c = 0;
% d = 82.10;
% e = 1.478;
 
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


LSM_initial = a-(a-b)./(1+((theta-c)/d).^e); %求出来是百分之多少
LSM_initial = LSM_initial/100;
% 
% theta = asin((UAVheight-BSheight)./UAVgrid_Bs_dist);
% theta = theta*180/pi;
% LSM_initial = 1./(1+75.*exp(-8.*(theta - 75)));


% 3GPP 36.777 LoS模型

% d1 = max(294.05*log10(UAVheight)-432.94,18);
% p1 = 233.98*log10(UAVheight) - 0.95;
% 
% 
% 
% 
% LSM_initial = 1./(1+75.*exp(-8.*(theta - 75)));

end