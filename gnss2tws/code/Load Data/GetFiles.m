function files = GetFiles(udir,form)
% 
% Description: Gets the list of files from the directory udir
% 
% Input:
%   udir            File directory that stores the data files 
%   form            File extension, e.g., *.up
% Output:
%   files           File list
% 
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

if ~isempty(udir) 
    file_tmp=ls(fullfile(udir,form));
else 
    error('the directory does not exist');
end

% Get the list of file full names
files = []; 
for i = 1:size(file_tmp,1)
    files = [files; fullfile(udir,file_tmp(i,:))];
end
