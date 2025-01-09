function outputArg1 = Compute_Rayline(Loc1,Loc2)
%COMPUTE_RAYLINE 计算基站与UAV之间的连线,Loc1是基站，Loc2是地图上一位置
%   输入为基站和UAV的3D位置坐标 输出为连线上的所有3D位置坐标，和2D位置坐标
%   2D坐标受网格限制，需要取整，用bresenham'lines算法或其他求栅格的算法 高度坐标直接由2D坐标和连线方程计算即可
Loc1_2D=Loc1(1:2);
Loc2_2D=Loc2(1:2);

Ray=Ray_line;
%Ray_2DLoc=Ray.Compute_Raypoint(Loc1_2D(1),Loc1_2D(2),Loc2_2D(1),Loc2_2D(2));%获得Loc1，Loc2交线上的点的二维坐标
Ray_2DLoc=Ray.Bresenham(Loc1_2D(1),Loc1_2D(2),Loc2_2D(1),Loc2_2D(2));%获得Loc1，Loc2交线上的点的二维坐标
%Ray_2DLoc=Ray.Bresenham(Loc1_2D(1),Loc1_2D(2),Loc2_2D(1),Loc2_2D(2));
k=(Loc2(3)-Loc1(3))/(norm(Loc2_2D-Loc1_2D));%nrom默认是求二范数
if Loc1_2D == Loc2_2D
    Ray_Height = Loc2(3);%选Loc1,Loc2中较大的值
else 
    Ray_Height = k*vecnorm(Ray_2DLoc-Loc1_2D,2,2)+Loc1(3);%vecnorm(A,p,2)计算矩阵A的第二维（每一行）的p-范数
end %忘了这个end,会导致Loc1==Loc2时Ray_3DLoc无输出值，输出空数组

Ray_3DLoc=[Ray_2DLoc,Ray_Height];

outputArg1 = Ray_3DLoc;%每个函数的输出要取一个有识别性的，debug容易找出来

end


