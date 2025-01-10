function H_L = Compute_PriorEntropy(LSM_prior)
%UNTITLED 计算LSM先验熵
%   此处显示详细说明



% [NUMX, NUMY] = size(LSM_prior);

H_temp = - LSM_prior.*log(LSM_prior + eps)-(1-LSM_prior+eps).*log(1-LSM_prior+eps);

H_L = sum(sum(H_temp));

end