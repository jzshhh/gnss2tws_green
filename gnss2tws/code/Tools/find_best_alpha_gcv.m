%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Select smoothing factor by GCV Method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lap_weight       smoothing factors

time = date2yr(datevec(num2str(GNSS_times),'yyyymmdd'));
GPS_data=-1*lsf_amplitude(time,data_recon);
% factor = [0.001:0.001:0.008 0.009:0.004:0.031];
factor = [0.001:0.001:0.006 0.008:0.003:0.017 0.020:0.005:0.040];
mean_res=nan(length(factor),1);
for i=1:length(factor)
    disp(['smooting factor: ' num2str(factor(i))]);
    pre_gps=nan(size(GPS_data,1),1);
    for j=1:size(GPS_data,1)
        Green_tmp=Green; Green_tmp(j,:)=[];
        GPS_data_tmp =GPS_data; GPS_data_tmp(j,:)=[];
        A=[Green_tmp; factor(i)*Lap]; d=[GPS_data_tmp; zeros(size(Lap,1),1)];
        %         ewh=inversion_type(A,d,[],inversion_flag);
        ewh=A\d;
        pre_gps(j,1)=Green(j,:)*ewh;
    end
    res_bos_pre=((GPS_data(:,1)-pre_gps(:,1))*10^3).^2;
    mean_res(i,1)=mean(res_bos_pre);
end

figure('color',[1 1 1])
plot(factor,mean_res,'ro-.','linewidth',1.5);

ylabel('CVSS (mm^2)','FontName','Times New Roman','FontSize',12)
xlabel('Smoothing factor','FontName','Times New Roman','FontSize',12)
set(gca,'xLim',[0.001 0.040]);

set(gcf,'Position',[200 200 500 400]);
saveas(gcf,'result/Smooth_factors.tiff');