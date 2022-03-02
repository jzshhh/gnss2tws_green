function Nearest_N_Points = calc_neighbors(data,N_nearest)
%
% Description: Find out the indexes of the nearest N_NEAREST points of every point in a regional coordinate dataset.
% This script is modified from the software PCAIM (http://www.tectonics.caltech.edu/resources/pcaim/)
%
% Input:
%   data                 Position coordinates of grids 
%   N_nearest            Number of nearest points
% Output:
%   Nearest_N_Points     Index list of the nearest N points of every point
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

n_points = size(data,1);

distance_matrix = zeros(n_points);

% Find the distance between every two points on the lower triangular
% portion of the distance_matrix
for ii = 1:n_points-1
    for jj = ii+1 : n_points
        distance_matrix(ii,jj) = dist_fcn(data(ii,:),data(jj,:));
    end
end

%%% Fill opposite entries of matrix, relying on the fact that dist_fcn(x,x) = 0
distance_matrix = distance_matrix + distance_matrix';

% Sort the distances, keep the index, and pull out the indexes of the
% N_nearest nearest points to each point on the fault
[~,I_dist] = sort(distance_matrix,2); 
Nearest_N_Points = (I_dist(:,2:1+N_nearest));
end

function dist = dist_fcn(x1,x2)
%DIST_FCN   Find the Eucliean norm between two input vectors
dist = norm(x1-x2);
end