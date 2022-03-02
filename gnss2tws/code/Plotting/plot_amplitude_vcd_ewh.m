function plot_amplitude_vcd_ewh(GPS_times,long_range,lati_range,GNSS_positions,data_recon,area_grid,ewh,boundary)
%
% Description: Calculate and plot annual amplitude of VCD and EWH time series
%
% Input:
%   GPS_times       Time list, format (8 int): yyyymmdd
%   long_range      Longitude range
%   lati_range      Latitude range
%   GNSS_positions  Longitude and latitude coordinates of all GNSS sites
%   data_recon      Reconstructed GNSS data
%   area_grid       Positions of grids
%   ewh             Time-varying gridded TWS changes  
%   boundary        Boundary of study area   
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

time = date2yr(datevec(num2str(GPS_times),'yyyymmdd'));
%% Calculate annual amplitude of VCD time series
for i=1:size(GNSS_positions,1)
    vcd_amp(i,1)=lsf_amplitude(time,data_recon(:,i));
end
%% Calculate annual amplitude of EWH time series
for i=1:size(area_grid,1)
    ewh_amp(i,1)=lsf_amplitude(time,ewh(:,i));
end

%% Plot annual amplitude of VCD and EWH time series
figure('color',[1 1 1])
set(gcf,'position',[20 20 1000 500]);
subplot(1,2,1)
scatter(GNSS_positions(:,1),GNSS_positions(:,2),15,vcd_amp*1000,'filled');
hold on
plot(boundary(:,1),boundary(:,2));
colormap(jet);
colorbar;
caxis([0 max(vcd_amp*1000)]);
grid on
title('VCD Amp. (mm)');
set(gca,'xlim',[min(boundary(:,1))-0.25, max(boundary(:,1))+0.25],'ylim',[min(boundary(:,2))-0.25, max(boundary(:,2))+0.25]);

[X,Y]=meshgrid(long_range,lati_range);
ewh_grid=griddata(area_grid(:,1),area_grid(:,2),ewh_amp,X,Y);

subplot(1,2,2)
pcolor(X,Y,ewh_grid*1000);
colormap(jet);
hold on
plot(boundary(:,1),boundary(:,2));
colorbar;
caxis([0 max(max(ewh_grid*1000))]);
grid on
title('EWH Amp. (mm)');
set(gca,'xlim',[min(boundary(:,1))-0.25, max(boundary(:,1))+0.25],'ylim',[min(boundary(:,2))-0.25, max(boundary(:,2))+0.25]);

saveas(gcf,'result/Amp_VCD_EWH.tiff');
end


function amplitude=lsf_amplitude(time,data)
%% Calculate annual amplitude of a time series
f=fittype('a+b*(time-time(1))+c*cos(2*pi*time)+d*sin(2*pi*time)+e*cos(4*pi*time)+f*sin(4*pi*time)','independent','time','coefficients',{'a','b','c','d','e','f'});
cfun=fit(time,data,f,'StartPoint', [0,0,0,0,0,0]);
amplitude=((cfun.c)^2+(cfun.d)^2)^0.5;
end
