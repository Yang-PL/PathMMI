% function CGM=create_CGM
%     CGM.create_CGM_indp=@create_CGM_indp;
%     CGM.create_CGM_correlation=@create_CGM_correlation;

function output_CGM = create_CGM(input_LSM,UAV_Bs_dist,input_para)
%CREATE_CGM 此处显示有关此函数的摘要,
% version 1:只能给出LSM网格上存在值的CGM
% version 2:给出飞行平面上任意一点的CGM
%   此处显示详细说明
[NUM_X,NUM_Y]=size(input_LSM);
flag=-input_LSM+2;%los索引Para第一组参数，nlos索引第二组参数
CGM=zeros(NUM_X,NUM_Y,2);%CGM存的是每个grid上的高斯分布的均值和方差,每个gird是相互独立的

for i=1:NUM_X
    for j=1:NUM_Y
        para=input_para(flag(i,j),:);
        CGM(i,j,1)=para(1)+10*para(2)*log10(UAV_Bs_dist(i,j));
        CGM(i,j,2)=para(3);
    end
end

output_CGM = CGM;

end

%function create_CGM_correlation=
