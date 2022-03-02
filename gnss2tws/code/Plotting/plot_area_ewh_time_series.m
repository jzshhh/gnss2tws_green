function plot_area_ewh_time_series(GNSS_times,area_grids,ewh,basin_file)
%
% Description: Calculate and plot regional average EWH time series
%
% Input:
%   GPS_times       Time list, format (8 int): yyyymmdd
%   area_grids      Positions of grids
%   ewh             Time-varying gridded TWS changes 
%   basin_file      Boundary of study area   
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

date = datevec(num2str(GNSS_times),'yyyymmdd');
year=date2yr(date);
average_ewh=cal_area_average_time_series(area_grids,ewh',basin_file); % Calculate regional average time series within study area

figure('color',[1 1 1])
plot(year,average_ewh*1000);
ylabel('EWH (mm)');
set(gca,'xlim',[year(1) year(end)]);
title('');
saveas(gcf,'result/Area_ewh_time_series.tiff');
end

function average_ewh=cal_area_average_time_series(area_grids,ewh_grids,bour)
%% Calculate regional weighted average time series within study area
index=inpolygon(area_grids(:,1),area_grids(:,2),bour(:,1),bour(:,2));
ok=find(index==1);
lonlat=area_grids(ok,:);ewh=ewh_grids(ok,:);

nn=0;
for i=1:length(ok)
    if ~isnan(ewh(i))
        nn=nn+1;
        temp(nn)=cosd(lonlat(i,2));
        ewh0(nn,:)=ewh(i,:).*temp(nn);
    end
end
average_ewh=sum(ewh0,1)./sum(temp);
end