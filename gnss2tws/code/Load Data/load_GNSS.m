function [sites,position,times,data]=load_GNSS(udir,form,site_info_file,timespan)
% 
% Description: Loading site information and GNSS data 
% 
% Input:
%   udir             File directory that stores the data files 
%   form             File extension, e.g., *.up
%   site_info_file   Site information file, format: name Longitude latitude elevation
%   timespan         Study period, Start and end dates, e.g., timespan=[20060101 20201231]
% Output:
%   sites            Site list, 4 char
%   position         Longitude and latitude coordinates of all sites
%   times            Time list, format (8 int): yyyymmdd
%   data             N*P GNSS data matrix, N: number of days, P: number of sites, NaN for missing data
% 
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

%% Save the epochs
all_days=datenum(datevec(num2str(timespan(1)),'yyyymmdd')):1:datenum(datevec(num2str(timespan(2)),'yyyymmdd'));
times=str2num(datestr(all_days,'yyyymmdd'));

%% Save site information
fid=fopen(site_info_file);
sites_info=textscan(fid,'%s %f %f %f');
sitetmp=char(sites_info{1});positmp=[sites_info{2} sites_info{3}];
fclose(fid);

files = GetFiles(udir,form);
[n,p] = size(files);
sites = files(:,p-2-length(form):p-length(form)+1);

position=NaN(n,2);
for i=1:n
    for j=1:length(sitetmp)
        if strcmpi(sites(i,:),sitetmp(j,:))
            position(i,:)=positmp(j,:);
            break;
        end
    end
    if isnan(position(i,1))
        error(['site: ' sites(i,:) ' does not exist in the sites.info file!']);
    end
end

%% Save GNSS data
data=NaN(length(all_days),n);
h=waitbar(0,'Loading GNSS data...');
for i=1:n           
    tmp=load(files(i,:));
    days=datenum(datevec(num2str(tmp(:,1)),'yyyymmdd'));
    [~,ok1,ok2]=intersect(all_days,days);
    data(ok1,i)=tmp(ok2,2);
    data(:,i)=movmean(filloutliers(data(:,i),'nearest','mean'),7,'omitnan'); % Applying an 7-day moving average filtering
    smg=['Loading GNSS: '  sites(i,:)];
    waitbar(i/n,h,smg)
end
close(h);

