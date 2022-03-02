function plot_gnss_vcd_L_U(GNSS_times,GNSS_positions,coeff,scores,boundary)
%
% Description: Plot temporal and spatial functions of each PC
%
% Input:
%   GPS_times       Time list, format (8 int): yyyymmdd
%   GNSS_positions  Coordinates of all GNSS sites
%   coeff           Spatial functions
%   scores          Temporal fucntions
%   boundary        Study area boundary
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

date = datevec(num2str(GNSS_times),'yyyymmdd');
year=date2yr(date);

%% plot temporal fucntions
figure('color',[1 1 1])
for i=1:size(coeff,2)
    subplot(size(coeff,2),1,i);
    plot(year,scores(:,i));
    title(['PC' num2str(i)]);
    set(gca,'xlim',[year(1) year(end)]);
end
saveas(gcf,'result/Temporal_functions.tiff');

%% plot spatial functions
figure('color',[1 1 1])
for i=1:size(coeff,2)
    subplot(1,size(coeff,2),i);
    scatter(GNSS_positions(:,1),GNSS_positions(:,2),15,coeff(:,i),'filled');
    hold on
    plot(boundary(:,1),boundary(:,2));
    colormap(jet);
    colorbar;
%     axis equal 
    caxis([min(coeff(:,i)) max(coeff(:,i))]);
    grid on
    title(['PC' num2str(i)]);
end
saveas(gcf,'result/Spatial_functions.tiff');