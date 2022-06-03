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
% Date: 10/03/2022 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

time = date2yr(datevec(num2str(GPS_times),'yyyymmdd'));
%% Calculate annual amplitude of VCD time series
vcd_amp=lsf_amplitude(time,data_recon);

%% Calculate annual amplitude of EWH time series
ewh_amp=lsf_amplitude(time,ewh);

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

% index=inpolygon(area_grid(:,1),area_grid(:,2),boundary(:,1),boundary(:,2));
% ewh_amp(~index)=NaN;
[X,Y]=meshgrid(long_range,lati_range);
ewh_grid=griddata(area_grid(:,1),area_grid(:,2),ewh_amp,X,Y);

subplot(1,2,2)
pcolor(X,Y,ewh_grid*1000);
colormap(jet);
hold on
plot(boundary(:,1),boundary(:,2));
colorbar;
caxis([0 300]);
grid on
title('EWH Amp. (mm)');
set(gca,'xlim',[min(boundary(:,1))-0.25, max(boundary(:,1))+0.25],'ylim',[min(boundary(:,2))-0.25, max(boundary(:,2))+0.25]);

saveas(gcf,'result/Amp_VCD_EWH.tiff');
end
