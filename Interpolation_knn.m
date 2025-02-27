function LSM_est_iter = Interpolation_knn(updated_grid,LSM_posterior)
%INTERPOLATION_KNN 将LSM中未更新过的位置由IDW-KNN插值更新。
%   此处显示详细说明

LSM_upa_iter = zeros(size(updated_grid,1),1);
for i = 1:size(updated_grid,1)
    LSM_upa_iter(i) = LSM_posterior(updated_grid(i,1),updated_grid(i,2));
end

Predic_Loc = zeros(800*800,2);
for i = 1:800
    disp(i)
    for j = 1:800 
        Predic_Loc((i-1)*800 + j,:) = [i,j];
    end
end
[~,idx1,~] = intersect(Predic_Loc,updated_grid,'rows'); % [common_rows,idx1,idx2] = intersect(ARRAY1,ARRAY2,'rows')
Predic_Loc(idx1,:) = [];


LSM_Vec_iter = IDW_KNN(updated_grid,LSM_upa_iter,Predic_Loc);
LSM_est_iter = ones(800,800);
Loc = [updated_grid;Predic_Loc];
Val = [LSM_upa_iter;LSM_Vec_iter];

for i = 1:size(Loc,1)
        LSM_est_iter(Loc(i,1), Loc(i,2)) = Val(i);
end

end

