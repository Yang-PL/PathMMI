function Ray = Ray_line
    Ray.Compute_Raypoint=@Compute_Raypoint;
    Ray.Compute_Raypoint_extension=@Compute_Raypoint_extension;
    Ray.Bresenham=@Bresenham_line;
    Ray.Bresenham_extension=@Brensenham_line_extension;
    Ray.Bresenham3D = @Bresenham3D_line; %三维空间中画线
    Ray.Bresenham3D_extension = @Bresenham3D_line_extension; %三维空间中画延长线
end


%返回交线的点
function Output1 = Compute_Raypoint(x1,y1,x2,y2)
    deltax=x2-x1;
    deltay=y2-y1;
    
%     %s1,s2=（1,1）第1象限；（-1，1）第2；（1，-1）第4；（-1，-1）第3
%     if(x2-x1>=0)%确定以Point1为原点，Point2是在14象限还是23象限
%         s1=1;%
%     else
%         s1=-1;
%     end
% 
%     if(y2-y1>=0)%%确定以Point1为原点，Point2是在23象限还是14象限
%         s2=1;
%     else
%         s2=-1;
%     end
    
    Ray_Point=[];
    if (deltax==0) 
        y=ceil(min(y1,y2)):floor(max(y1,y2));%若floor(max(y1,y2))-ceil(min(y1,y2))=-1,x,y都是空的向量
        if floor(max(y1,y2))-ceil(min(y1,y2)) == -1 %y == []
            y = [ceil(y2),floor(y1)];
        end
        y=y';
        x=x1*ones(length(y),1);
        Ray_Point=[x,y];
    else
        k=deltay/deltax;
        x=ceil(min(x1,x2)):floor(max(x1,x2));
        if floor(max(x1,x2))-ceil(min(x1,x2)) == -1 %x == []
            x = [ceil(x2),floor(x1)];
        end
        [~,index]=find([x1,x2]==min(x1,x2));
        Point_y=[y1,y2];
        y=Point_y(index)+k*(x-min(x1,x2));
        y=[ceil(y),floor(y)];
        x=[x,x];
        Ray_Point = [x',y'];
        [~,index] = find(y>800 | y<=0);
        Ray_Point(index,:) = [];
    end
   % [~,index] = find(x>800,y>800)
    Ray_Point = unique(Ray_Point,"rows"); %去掉重复元素
    %find(Ray_Point == )               %去掉Rx的点，即点（x2,y2）;
    Output1=floor(Ray_Point);
    
    

end
    
    
function Output1 = Compute_Raypoint_extension(x1,y1,x2,y2,Map_lowBound,Map_UpBound)%方形，长和宽的上下界是一致的
    deltax = x2-x1;
    deltay = y2-y1;
    Ray_Point_extension = [];
    if(deltax == 0)&&(deltay == 0)
        Ray_Point_extension = [];
    end

    if(deltax == 0)
        if(deltay>0)
            y = ceil(y2):Map_UpBound;
            y = y';
            x = x1*ones(length(y),1);
            Ray_Point_extension = [x,y];
        else
            y = Map_lowBound:floor(y2);
            y = y';
            x = x1*ones(length(y),1);
            Ray_Point_extension = [x,y];
        end
    else
        k = deltay/deltax;
        k1 = (Map_UpBound - y1)/(Map_UpBound - x1);%地图边界四个角与基站连线的斜率，顺时针来数
        k2 = (Map_lowBound - y1)/(Map_UpBound - x1);
        k3 = (Map_lowBound - y1)/(Map_lowBound - x1);
        k4 = (Map_UpBound - y1)/(Map_lowBound - x1);

        if(k2 <= k) && (k <= k1) && (deltax > 0)
           x = ceil(x2):Map_UpBound;
           y = y2 + k*(x - x2);
           y = [ceil(y),floor(y)];%这种选点的方法而不是bresenham's line，可能会有误差传播的问题
           x = [x,x];
           Ray_Point_extension = [x',y'];
           [~,index] = find(y>800 | y<=0);
           Ray_Point_extension(index,:) = [];

        elseif((k < k2) || (k > k3)) && (deltay < 0)
           y = Map_lowBound:floor(y2);
           x = x2 + 1/k*(y - y2);
           x = [ceil(x),floor(x)];
           y = [y,y];
           Ray_Point_extension = [x',y'];
           [~,index] = find(x>800 | x<=0);
           Ray_Point_extension(index,:) = [];
        elseif(k4 <= k) && (k <= k3) && (deltax < 0)
            x = Map_lowBound:floor(x2);
            y = y2 + k*(x - x2);
            y = [ceil(y),floor(y)];%这种选点的方法而不是bresenham's line，可能会有误差传播的问题
            x = [x,x];
            Ray_Point_extension = [x',y'];
            [~,index] = find(y>800 | y<=0);
            Ray_Point_extension(index,:) = [];
        elseif((k < k4) || (k > k1)) && (deltay > 0)
            y = ceil(y2):Map_UpBound;
            x = x2 + 1/k*(y - y2);
            x = [ceil(x),floor(x)];
            y = [y,y];
            Ray_Point_extension = [x',y'];
            [~,index] = find(x>800 | x<=0);
            Ray_Point_extension(index,:) = [];
        end
    end

    Ray_Point_extension = unique(Ray_Point_extension,"rows"); %去掉重复元素
   % Ray_Point_extension(1,:) = [];
  % Ray_Point_extension(end,:) = [];
    Output1 = floor(Ray_Point_extension);

end






function Output1 = Bresenham_line(x1,y1,x2,y2)%[outputArg1,outputArg2] =
%BRESENHAM 此处显示有关此函数的摘要
%   此处显示详细说明


%hold on;
Ray_Point = [];
steep = abs(y2 - y1) > abs(x2-x1);
if steep 
    [x1,y1] = swap(x1,y1);
    [x2,y2] = swap(x2,y2);
end
if x1 > x2
    [x1,x2] = swap(x1,x2);
    [y1,y2] = swap(y1,y2);
end
deltax = x2 - x1;
deltay = abs(y2 - y1);
error = 0;
deltaerr = deltay/deltax;
ystep = 0;
y = y1;
if y1 < y2
    ystep = 1;
else
    ystep = -1;
end
for x = x1:x2
    if steep 
       % scatter(y,x);
        Ray_Point = [Ray_Point;[y,x]];
    else
       % scatter(x,y);
        Ray_Point = [Ray_Point;[x,y]];
    end
    error = error +deltaerr;
    if error >=0.5
        y = y + ystep;
        error = error - 1;
    end


end


%剔除不在连线上的点，都是在数组的开头和末尾


%Ray_Point(1,:) = [];
%Ray_Point(end,:) = [];



%Output1 = floor(Ray_Point);
Output1 = ceil(Ray_Point);

%[rowIdx,colIdX] = find(Ray_Point==0);
%Ray_point(rowIdx,:)=[];
end

function Brensenham_line_extension(x1,y1,x2,y2,Map_lowBound,Map_UpBound)
%BRESENHAM 求延长线，用Brensenham_line求延长线上的点
%   此处显示详细说明
    steep = abs(y2 - y1) > abs(x2 - x1);
    if steep
        [x1,y1] = swap(x1,y1);
        [x2,y2] = swap(x2,y2);
    end
    deltax = abs(x2 - x1);
    deltay = abs(y2 - y1);
    error = 0;
    

    
end

function Bresenham3D_line(x_bs,x_uav)


    



end
