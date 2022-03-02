function [ewh,X_pred]=recon_ewh_predi_vcd(scores,ewh_pc,G)
%
% Description: Calculate time-varying total TWS changes at all grids and predicted displacement time series at all GNSS stations.
%
% Input:
%   G              Green's functions
%   scores         Temporal functions
%   ewh_pc         EWH PCs
% Output:
%   ewh            Total TWS changes
%   X_pred         Predicted displacement time series
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

h=msgbox('Restructure total TWS changes and create predictions!');
ewh=scores*ewh_pc';
X_pred=(G*ewh')';
close(h);
end