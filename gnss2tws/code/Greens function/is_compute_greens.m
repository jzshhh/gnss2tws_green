function Green=is_compute_greens(gnss_lonlat,grid_lonllat,GNSS_sites,alph)
%
% Description: Calculate Green's functions when LGFs.mat does not exist or GNSS sites and area grids are changed
%
% Input:
%   gnss_lonlat          Positions of GNSS sites
%   grid_lonllat         Positions of grids
%   GNSS_sites           GNSS site list
%   alph                 Mesh spacing
% Output:
%   Green                Matrix of Green's functions
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

if exist('result/LGFs.mat','file')
    load('result/LGFs.mat','GNSS_bak','Green','load_bak');
    if ~isequal(GNSS_bak,gnss_lonlat)||~isequal(load_bak,grid_lonllat)
        Green=compute_greens(gnss_lonlat,grid_lonllat,GNSS_sites,alph); %Recalculate Green's functions when GPS sites and area grids are changed
    else
        disp('Greens function exists!');
    end
else
    Green=compute_greens(gnss_lonlat,grid_lonllat,GNSS_sites,alph); %Calculate Green's functions when 'LGFs.mat' does not exist
end