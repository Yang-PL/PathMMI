function predict_meas = IDW_KNN(rMeasloc,rMeas,predict_loc)
%UNTITLED4 predict_meas输出被插值位置predict_loc的插值数值
%   此处显示详细说明
[Idx,Dis] = knnsearch(rMeasloc,predict_loc,'K',5,'NSMethod','kdtree');
%权重

% 对于有测量值的位置不进行插值。

% 对于没有测量值的位置进行插值。

Inv_Dis = 1./(Dis+eps);%+eps); % 不加eps，更新的位置会出现NaN,因为有0值
%Inv_Dis = 1./Dis;%+eps); % 不加eps，更新的位置会出现NaN,因为有0值
w = Inv_Dis./sum(Inv_Dis,2);

%predict_meas = w*rMeas(Idx);%w%sum(rMeas(Idx).*w,2);
%predict_meas = w*rMeas(Idx);
predict_meas = sum(rMeas(Idx).*w,2);

end