%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Select smoothing factor by GCV Method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lap_weight       smoothing factors

lap_weight = [0.006:0.003:0.042];

for i=1:length(lap_weight)
    aa=sprintf('Smoothing factor: %5.3f', lap_weight(i));
    disp(aa);
    mean_res(i,1)=GCV_smoothing_factor(Green,coeff,Lap,lap_weight(i),inversion_flag,scores,data_recon);
end

save result/GCV_smoothing_factor.mat lap_weight mean_res

%% plot the figure
figure('color',[1 1 1])
plot(lap_weight,mean_res,'ro-.','linewidth',1.5);
ylabel('CVSS (mm^2)','FontName','Times New Roman','FontSize',12)
xlabel('Smoothing factor','FontName','Times New Roman','FontSize',12)
set(gca,'xLim',[0.005 0.042]);

saveas(gcf,'result/GCV_smoothing_factor.tiff');

function mean_res_all=GCV_smoothing_factor(Green,coeff,Lap,lap_weight,inversion_flag,scores,data_recon)
%
% Description: Determining smoothing_factor based generalized cross validation
%
% Input:
%   Green              Green's functions
%   coeff              Spatial functions
%   Lap                Laplacian matrix
%   lap_weight         Smoothing factor
%   inversion_flag     Inversion method
%   data_recon         Reconstructed GNSS data
%   scores             Spatial functions
% Output:
%   mean_res_all       Sum of squared residuals from cross validation
%
% Author: Zhongshan Jiang
% Date: 10/03/2022 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

pre_gps=nan(size(data_recon));
for i=1:size(coeff,1)
    % Remove one GNSS station in each loop
    Green_tmp=Green; Green_tmp(i,:)=[];
    GPS_data_tmp =coeff; GPS_data_tmp(i,:)=[];
    % Do inversion model using remaining data points
    [ewh_pc]=inversion_ewh(Green_tmp,GPS_data_tmp,Lap,lap_weight,inversion_flag);
    ewh=scores*ewh_pc';
    % Calculate prediction at the removed station
    pre_gps(:,i)=Green(i,:)*ewh';
end
% Calculate differences between GNSS data and model predictions
res_bos_pre=((data_recon-pre_gps)*10^3).^2;
% Calculate averages of obs-pre differences at all stations for each epoch
mean_res=mean(res_bos_pre,2);
% Calculate averages of the above differences at all epoches
mean_res_all=mean(mean_res);
end

function [ewh]=inversion_ewh(A,obs,L,gamma,inversion_flag)
A_L = [A;gamma*L];
ewh=nan(size(A,2),size(obs,2));
for i=1:size(obs,2)
    d=[obs(:,i); zeros(size(L,1),1)];
    ewh(:,i)=inversion_method(A_L,d,inversion_flag);
end
end

function s=inversion_method(A,d,inversion_flag)
switch(inversion_flag)
    case 'LS'
        s=A\d;
    case  'pinv'
        s=pinv(A) * d;
    case 'lsqlin'
        options = optimset('LargeScale','on','DiffMaxChange',1e-1,'DiffMinChange',1e-9,'TolCon',1e-9,'TolFun',1e-9,'TolPCG',1e-9,'TolX',1e-9,'MaxIter',1e9,'MaxPCGIter',1e9,'Display','off');
        % lb=  -1.00*ones(size(A,2),1); ub= 1.00*ones(size(A,2),1); % using boundary constraints for model parameters
        lb=[]; ub=[];
        [s,resnorm]=lsqlin(A,d,[],[],[],[],lb,ub,[],options);
end
end



