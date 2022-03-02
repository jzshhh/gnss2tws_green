function [sinang,cosang] = angrad(alat,alon,blat,blon)
%
% Description: Calculate the angular distance between two points on the Earth
%
% Input:
%   alat        Latitude of the first point
%   alon        Longitude of the first point
%   blat        Latitude of the second point
%   blon        Longitude of the second point
% Output:
%   sinang       Sine of the angular distance
%   cosang       Cosine of  the angular distance
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

cosang = sind(alat)*sind(blat)+cosd(alat)*cosd(blat)*cosd(alon-blon);
sinang = sqrt(1-cosang*cosang);
end