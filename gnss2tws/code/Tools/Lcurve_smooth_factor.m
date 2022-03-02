%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Selecting Smoothing Factor by L Curve Method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lap_weight       smoothing factors

lap_weight = [0.005:0.001:0.01 0.012:0.002:0.016 0.02:0.01:0.1];
for i=1:length(lap_weight)
    aa=sprintf('Smoothing factor: %5.3f', lap_weight(i));
    disp(aa);
    [misfit(i,1),roughness(i,1)]=Lcurve_smoothing_factor(Green,coeff,Lap,lap_weight(i),inversion_flag,scores,data_recon);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Plot L curve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('color',[1 1 1])
plot(roughness/max(roughness),misfit/max(misfit),'ro-.','linewidth',1.5);hold on
plot(roughness(9)/max(roughness),misfit(9)/max(misfit),'pb','linewidth',1.5,'MarkerSize',15);
ylabel('Normalized Misfit','FontName','Times New Roman','FontSize',12);
xlabel('Normalized Roughness','FontName','Times New Roman','FontSize',12);
for i=1:length(lap_weight)
    text(roughness(i)/max(roughness)+.01,misfit(i)/max(misfit),sprintf('%5.3f',lap_weight(i)));
    hold on
end
export_fig('result/Lcurve_smooth_factor.pdf');


function [misfit,roughness ]=Lcurve_smoothing_factor(Green,coeff,Lap,lap_weight,inversion_flag,scores,data_recon)
%
% Description: Calculation of misfit and roughness for one smoothing factor
%
% Input:
%   Green            Matrix of Green's functions
%   coeff            Space functions
%   score            Temporal fucntions
%   lap_weight       Smoothing factors
%   inversion_flag   Inversion method
%   Lap              Laplacian matrix
%   data_recon       Reconstructed GNSS data
% Output:
%   misfit          Data missfit
%   roughness       Model roughness
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

[ewh_pc]=inversion_model(Green,coeff,Lap,lap_weight,inversion_flag);
ewh=scores*ewh_pc';

pre_gnss=Green*ewh';
rou_model=Lap*ewh';

misfit_tmp = sqrt(sum((pre_gnss-data_recon').^2,1));
roughness_tmp = sqrt(sum(rou_model.^2,1));

misfit=norm(misfit_tmp,2)/size(scores,1);
roughness=norm(roughness_tmp,2)/size(scores,1);
end

