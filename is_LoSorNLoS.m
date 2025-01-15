function LSM_real = is_LoSorNLoS(Bs_Loc,loc,Build_Map)
%IS_LOSORNLOS 此处显示有关此函数的摘要
%   确定地图上任一栅格的链路状态LOS/NLOS
[NUM_X,~]=size(Build_Map);
Ray_Point = Compute_Rayline(Bs_Loc,loc);

label = (Ray_Point(:,2)-1)*NUM_X+Ray_Point(:,1);

flag = (Ray_Point(:,3) <= Build_Map(label));

if sum(flag) == 0 %
    LSM_real = 1; %1表示los，0表示nlos
else
    LSM_real = 0;
end
end


