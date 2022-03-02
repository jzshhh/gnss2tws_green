function area_grid=make_area_grid(long, lat,study_area_border)
%
% Description: Creating grids in the study area
% Input:
%   long              Longitude range
%   lat               Latitude range
%   study_area_border Extended border of study area
% Output:
%   area_grid         Geographical coordinates of grid points within the border
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

[along, alat]=meshgrid(long,lat);
blong=reshape(along',[],1);
blat=reshape(alat',[],1);

in = inpolygon(blong,blat,study_area_border(:,1),study_area_border(:,2));
area_grid=[blong(in,1) blat(in,1)];

%% plot to view
% plot(blong(in),blat(in),'*r',blong(~in),blat(~in),'og');
% hold on 
% plot(study_area_border(:,1),study_area_border(:,2));




