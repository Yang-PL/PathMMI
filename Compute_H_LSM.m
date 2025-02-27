function H = Compute_H_LSM(LSM_est)
%COMPUTE_H_LSM 此处显示有关此函数的摘要
%   此处显示详细说明

[NUMX,NUMY] = size(LSM_est);
H = -1./(NUMX * NUMY) .* sum(sum(log(LSM_est + eps).*LSM_est + log(1 - LSM_est + eps) .* (1 - LSM_est)));

end

