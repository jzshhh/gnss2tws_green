function [h,l,k]=load_LLNs
% Read the load Love numbers from the file 'PREM-LLNs-complete.dat'
fname='code\Greens function\PREM-LLNs-complete.dat';
fid=fopen(fname,'r+');
data=textscan(fid,'%d %f %f %f %f %f','headerlines',1);
fclose(fid);
h=cell2mat(data(2));
l=cell2mat(data(3));
k=cell2mat(data(4));
end
