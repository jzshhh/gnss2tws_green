%%%Checkerboard test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate checkerboard EWH for the forward calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_ewh=0.3;
[lon0, lat0]=meshgrid(long,flipud(lat));
[nx,ny]=size(lon0);
grid=zeros(nx,ny);
nnx=8;nny=8;
for i=1:2:fix(nx/nnx)
    for j=1:2:fix(ny/nny)
        grid(nnx*(i-1)+1:nnx*i,nny*(j-1)+1:nny*j)=max_ewh;
    end
end

for i=2:2:fix(nx/nnx)
    for j=2:2:fix(ny/nny)
        grid(nnx*(i-1)+1:nnx*i,nny*(j-1)+1:nny*j)=max_ewh;
    end
end

% imshow(grid);
lon1 = reshape(lon0,[],1);
lat1 = reshape(lat0,[],1);
grid_in = reshape(grid,[],1);
grid_in(isnan(grid_in))=0;
ewh_in = zeros(size(area_grid,1),1);
for i=1:size(area_grid,1)
    ok1 = find(lon1 == area_grid(i,1));
    ok2 = find(lat1 == area_grid(i,2));
    ok3 = intersect(ok1,ok2);
    if ~isempty(ok3)
    ewh_in(i,1) = grid_in(ok3);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Forward and inversion modeling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GPS_data(:,1)=Green*ewh_in; GPS_data(:,2)=ones(size(Green,1),1)*0.005; % Calculate forward displacement
A_L = [Green;lap_weight*Lap]; d=[GPS_data(:,1); zeros(size(Lap,1),1)];
ewh_out=inversion_type(A_L,d,inversion_flag); % Invert displacement for EWH

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Plot result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ewh_input = zeros(size(lon1,1),1);
ewh_output = zeros(size(lon1,1),1);
for i=1:size(lon1,1)
    ok1 = find(area_grid(:,1) == lon1(i));
    ok2 = find(area_grid(:,2) == lat1(i));
    ok3 = intersect(ok1,ok2);
    if ~isempty(ok3)
        ewh_input(i,1) = ewh_in(ok3);
        ewh_output(i,1) = ewh_out(ok3);
    end
end
ewh_input = reshape(ewh_input,size(lon0,1),size(lon0,2));
ewh_output = reshape(ewh_output,size(lon0,1),size(lon0,2));

figure('color',[1 1 1])
%% Plot input checkerboard EWH 
set(gcf,'Position',[20 20 1050 600]);
subplot('Position',[0.05 0.4 0.45 0.4])
ewh_in=ewh_input*1000;
pcolor(lon0,lat0,ewh_in);

hold on
plot(boundary(:,1),boundary(:,2),'k-','linewidth',1);
daspect([1 1 1]);

hold on
plot(GNSS_positions(:,1),GNSS_positions(:,2),'o','Markerfacecolor','g','markeredgecolor','g','Markersize',2);
set(gca,'xlim',[min(long_bou)-0.25, max(long_bou)+0.25],'ylim',[min(lat_bou)-0.25, max(lat_bou)+0.25]);
hold off
title('(a)');

%% Plot inverted EWH 
subplot('Position',[0.55 0.4 0.45 0.4])
ewh_out=ewh_output*1000;
pcolor(long,lat,ewh_out);

hold on
plot(boundary(:,1),boundary(:,2),'k-','linewidth',1);
daspect([1 1 1]);
hold on
plot(GNSS_positions(:,1),GNSS_positions(:,2),'o','Markerfacecolor','g','markeredgecolor','g','Markersize',2);
set(gca,'xlim',[min(long_bou)-0.25, max(long_bou)+0.25],'ylim',[min(lat_bou)-0.25, max(lat_bou)+0.25]);
hold off

set(gca,'CLim',[0 max_ewh*1000]);
set(gca,'xaxislocation','top','yaxislocation','right','xaxislocation','bottom','yaxislocation','left');
title('(b)');
view(2);

axes('position',[0.28 0.25 0.5 0.2])
set(gca,'CLim',[0 max_ewh*1000]);
colormap(flipud(hot(12)));
set(gca,'FontSize',12,'FontName','Times New Roman');
h=colorbar('location','south','FontSize',12);
h.Label.String = 'EWH (mm)';
axis off

saveas(gcf,'result/Checkerboard_test.tiff');

