function ind_pts_edge=find_edges(grid_lonlat)
%
% Description: Find out the indexes of edge points in a regional gridded data
% This script is modified from the software PCAIM (http://www.tectonics.caltech.edu/resources/pcaim/)
% Input:
%   grid_lonlat            Grid coordinates
% Output:
%   ind_pts_edge           Index of edge points 
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

eps=1.e-1;

x=grid_lonlat(:,1);y=grid_lonlat(:,2);
npts=numel(x);

x_min=min(x);x_max=max(x);
y_min=min(y);y_max=max(y);

dy1=sort(abs(diff(y)));
dx1=sort(abs(diff(x)));

ind_y1=find(dy1>eps);dy1=dy1(ind_y1);dy=dy1(1);
ind_x1=find(dx1>eps);dx1=dx1(ind_x1);dx=dx1(1);

n_int_y=length(y_min:dy:y_max);

yi=y_min-dy/2;
yf=yi+dy;
right_point=zeros(3,n_int_y);
left_point=zeros(3,n_int_y);

index_lr=zeros(2*n_int_y,1);

for ii=1:n_int_y
    ic=find(y>=yi & y<=yf);
    x_tmp=x(ic);
    
    if ~isempty(x_tmp)
        [x_tmp_sorted,ind_x_tmp_sorted]=sort(x_tmp,'ascend');
        ind_left_pt=find(x==x_tmp_sorted(1));
        ind_right_pt=find(x==x_tmp_sorted(end));
        
        ind_left_pt=intersect(ic,ind_left_pt);
        ind_right_pt=intersect(ic,ind_right_pt);
        
        left_point(1,ii)=x(ind_left_pt);
        left_point(2,ii)=y(ind_left_pt);
        
        right_point(1,ii)=x(ind_right_pt);
        right_point(2,ii)=y(ind_right_pt);
        
        index_lr(2*ii-1)=ind_left_pt;
        index_lr(2*ii)=ind_right_pt;      
    end
    yi=yf;
    yf=yi+dy;
end

index_lr=index_lr(find(index_lr~=0));
index_lr=unique(index_lr);

xi=x_min-dx/2;
xf=xi+dx;

n_int_x=length(x_min:dx:x_max);

upper_point=zeros(3,n_int_x);
lower_point=zeros(3,n_int_x);

index_ud=zeros(2*n_int_x,1);

for ii=1:n_int_x
    ic=find(x>=xi & x<=xf);
    y_tmp=y(ic);
    
    if ~isempty(y_tmp)
        [y_tmp_sorted,ind_y_tmp_sorted]=sort(y_tmp,'ascend');
        ind_lower_pt=find(y==y_tmp_sorted(1));
        ind_upper_pt=find(y==y_tmp_sorted(end));
        
        ind_lower_pt=intersect(ic,ind_lower_pt);
        ind_upper_pt=intersect(ic,ind_upper_pt);
        
        lower_point(1,ii)=x(ind_lower_pt);
        lower_point(2,ii)=y(ind_lower_pt);
        
        upper_point(1,ii)=x(ind_upper_pt);
        upper_point(2,ii)=y(ind_upper_pt);
                
        index_ud(2*ii-1)=ind_lower_pt;
        index_ud(2*ii)=ind_upper_pt;
    end
    xi=xf;
    xf=xi+dx;
end
index_ud=index_ud(find(index_ud~=0));
index_ud=unique(index_ud);


ind_pts_edge=[index_lr;index_ud];
ind_pts_edge=unique(ind_pts_edge);
ind_pts_edge=ind_pts_edge';
