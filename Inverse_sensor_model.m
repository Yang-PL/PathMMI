function Inverse=Inverse_sensor_model
       Inverse.Gaussian = @Gaussian;
       Inverse.pdflog_ln_zn= @pdflog_ln_zn;
       Inverse.pdflog_l1_zn = @pdflog_lb_zn;  %Tx和Rx连线上的点
       Inverse.pdflog_l2_zn = @pdflog_le_zn;  %Tx和Rx连线延长线上的点
       Inverse.pdflog_l3_zn = @pdflog_lo_zn;  %其他方向上的点
end

function pdf = Gaussian(x,mu,var)
%GAUSSIAN 一维高斯函数    
%   此处显示详细说明
pdf=1/(var*(sqrt(2*pi)))*exp(-(x-mu)^2/(2*var));

end

function pdflog = pdflog_ln_zn(zn,mu_g,var_g,var_meas,p_ln_los)   %mu,var是2x1的向量,分为los,nlos
     pdf = zeros(length(mu_g),1);
     pdf(1) = Gaussian(zn,mu_g(1),var_g(1)+var_meas)*p_ln_los/(Gaussian(zn,mu_g(1),var_g(1)+var_meas)*p_ln_los+...
             (Gaussian(zn,mu_g(2),var_g(2)+var_meas)*(1-p_ln_los)));    %p_ln=los_RSS
     pdf(2) = 1 - pdf(1);       % p_ln=nlos_RSS
     pdflog = log(pdf(1)/pdf(2));
end


function pdflog = pdflog_lb_zn(zn,mu_g,var_g,var_meas,p_ln_los,p_lb_los)
    pdf = zeros(length(mu_g),1);
    pdf(1) = Gaussian(zn,mu_g(1),var_g(1)+var_meas)*p_ln_los+...
        Gaussian(zn,mu_g(2),var_g(2)+var_meas)*(p_lb_los-p_ln_los);%p(lp=los|zt,xt);%pdf(1)可能出现负值
    pdf(2) = Gaussian(zn,mu_g(2),var_g(2)+var_meas)*(1-p_lb_los); %p(lk=nlos|zt,xt);
    pdf = pdf/sum(pdf);%归一化，得到概率%(1-p_lk_los)等于0时，会使得pdf出现奇异值
    pdflog = log(pdf(1)/pdf(2));
end


function pdflog = pdflog_le_zn(zn,mu_g,var_g,var_meas,p_ln_los,p_le_los)
    pdf = zeros(length(mu_g),1);
    pdf(1) = Gaussian(zn,mu_g(1),var_g(1)+var_meas)*p_le_los;%p(lk=los|zt,xt);
    pdf(2) = Gaussian(zn,mu_g(1),var_g(1)+var_meas)*(p_ln_los-p_le_los)+...
        Gaussian(zn,mu_g(2),var_g(2)+var_meas)*(1-p_ln_los);
                %p(lk=nlos|zt,xt);
    pdf = pdf/sum(pdf);%归一化，得到概率
    pdflog = log(pdf(1)/pdf(2));
end


