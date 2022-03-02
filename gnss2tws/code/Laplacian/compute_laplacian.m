function Lap=compute_laplacian(area_grid,n_neighbours)
%
% Description: Compute Laplacian matrix
%
% Input:
%   area_grid       Positions of grids
%   n_neighbours    Number of neighbor points used for calculating Laplacian matrix
% Output:
%   Lap             Laplacian matrix
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

h=waitbar(0,'Calculate Laplacian matrix...');
Lap=zeros(size(area_grid,1));
nn=0;
%% Buliding Laplacian matrix for interior points using Template L4
%   L4=[0  1 0]
%      [1 -4 1]
%      [0  1 0]
interior_model=find_interior(area_grid,n_neighbours);
for i=1:size(interior_model,1)
    Lap(interior_model(i,1),interior_model(i,1))=-4;
    Lap(interior_model(i,1),interior_model(i,2))=1;
    Lap(interior_model(i,1),interior_model(i,3))=1;
    Lap(interior_model(i,1),interior_model(i,4))=1;
    Lap(interior_model(i,1),interior_model(i,5))=1;
    nn=nn+1;
    waitbar(nn/size(area_grid,1),h)
end

%% Buliding Laplacian matrix for edge points using Template L2
% L2=[1  -2 1]
ind_pts_edge=find_edges(area_grid);
edge_neighbors = calc_neighbors(area_grid(ind_pts_edge,:),2);
edge_model=[ind_pts_edge' edge_neighbors];
for i=1:size(edge_model,1)
    Lap(edge_model(i,1),edge_model(i,1))=-2;
    Lap(edge_model(i,1),edge_model(i,2))=1;
    Lap(edge_model(i,1),edge_model(i,3))=1;
    nn=nn+1;
    waitbar(nn/size(area_grid,1),h)
end
close(h);
end


function interior_model=find_interior(point,n_neighbours)
grid_point=1:length(point);
Nearest_N_Points = calc_neighbors(point,n_neighbours);
Nearest_All_Points=[grid_point' Nearest_N_Points];
ind_pts_edge=find_edges(point);
interior_model=Nearest_All_Points(setxor(Nearest_All_Points(:,1),ind_pts_edge),:);
end


