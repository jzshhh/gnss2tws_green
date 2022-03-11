function [ewh]=inversion_model(A,obs,L,gamma,inversion_flag)
%
% Description: Inverting GNSS Spatial functions for EWH 
% Input:
%   A              Green's function matrix
%   obs            Observation vectors consisting of spatial functions of each PC
%   L              Laplacian matrix
%   gamma          Smoothing factor
%   inversion_flag Inversion method
% Output:
%   ewh            EWH components
%
% Author:       Zhongshan Jiang        
% Organization: Southwest Jiaotong University 
% E-mail:       jzshhh@my.swjtu.edu.cn
% Date:         03/11/2022

h=waitbar(0,'Inverting PCs for EWH...');
A_L = [A;gamma*L];
ewh=nan(size(A,2),size(obs,2));
for i=1:size(obs,2)
    d=[obs(:,i); zeros(size(L,1),1)];
    % Perform the inversion for each EWH component with inversion_type
    ewh(:,i)=inversion_type(A_L,d,inversion_flag);
    smg=['Inverting PC'  num2str(i) ' for EWH components'];
    waitbar(i/size(obs,2),h,smg)
end
close(h);
