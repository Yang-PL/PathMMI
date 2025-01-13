function [H_L, H_sum] = Compute_PriorEntropy(LSM_prior)
%UNTITLED 计算LSM先验熵
%   两个输出：H_L，地图先验熵矩阵  H_sum，地图先验熵之和



% [NUMX, NUMY] = size(LSM_prior);

H_L = - LSM_prior.*log(LSM_prior + eps) - (1 - LSM_prior + eps).*log(1 - LSM_prior + eps);

H_sum = sum(sum(H_L));

end