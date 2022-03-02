function plot_gnss_time_series(GNSS_sites,GNSS_times,data_raw,data_pre)
%
% Description: Calculate and plot regional average EWH time series
%
% Input:
%   GNSS_sites    GNSS site list, 4 char
%   GPS_times     Time list, format (8 int): yyyymmdd
%   data_raw      GNSS raw data
%   data_pre      Predicted displacement time series
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

date = datevec(num2str(GNSS_times),'yyyymmdd');
year=date2yr(date);

for i=1:size(data_raw,2)
    figure('color',[1 1 1])
    plot(year,data_raw(:,i)*1000,'k')
    hold on
    plot(year,data_pre(:,i)*1000,'r');
    ylabel('Up (mm)');
    set(gca,'xlim',[year(1) year(end)]);
    legend('Obs','Pre');
    title(GNSS_sites(i,:));
    pause(3);
    delete(gcf);
end