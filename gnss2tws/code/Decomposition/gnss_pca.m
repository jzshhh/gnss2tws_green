function [coeff,score,var_explained_PCA,explained,data_recon]=gnss_pca(data_raw,num_pc)
% 
% Description: Performing PCA decomposition using the 'als' algorithm for missing data
% 
% Input:
%   data_raw         Raw observation data
%   num_pc           Number of selected PCs 
% Output:
%   coeff            Spatial functions
%   score            Temporal fucntions
%   all_percents     Variance contribution of selected PCs to raw GNSS data
%   explained        Variance contribution of each PC to the filtered data
%   data_recon       Reconstructed GNSS data
% 
% Author: Zhongshan Jiang
% Date: 11/03/2022 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

%% Implementing PCA decomposition, algorithm 'als'
h=msgbox('Implement PCA decomposition, algorithm: ''als'', please wait!');

%% Using built-in pca.m fucntion in Matlab's Statistics and Machine Learning Toolbox
% opt = statset('pca'); opt.MaxIter = 2000; opt.Display = 'iter'; 
% [coeff,score,latent,tsquared,explained,mu] = pca(data_raw,'algorithm','als','Centered','off','NumComponents',num_pc,'Options',opt);

%% PCA decomposition using 'als' algorithm, which is modified according to the Matlab's built-in pca.m script
Is_Centered=false; % Centralized observation matrix (true or false)
% Options for als algorithm, including four parameters:
%   'Display' - Level of display output.  Choices are 'off' (the default), 'final', and 'iter'.
%   'MaxIter' - Maximum number of steps allowed. The default is 1000. Unlike in optimization settings, reaching MaxIter is regarded as convergence.
%   'TolFun' - Positive number giving the termination tolerance for the cost function.  The default is 1e-6.
%    'TolX' - Positive number giving the convergence threshold for relative change in the elements of L and R.The default is 1e-6.
opt.MaxIter = 2000; opt.Display = 'iter';opt.TolFun = 1e-6; opt.TolX = 1e-6; 
[coeff,score,latent,explained,mu] = pca_als(data_raw,num_pc,Is_Centered,opt); 
data_recon = score*coeff' + repmat(mu,size(data_raw,1),1);

%% Calcuating variance contribution of selected PCs to raw GNSS data
no_site=size(data_raw,2);
var_r=zeros(no_site,1);
Var_d=zeros(no_site,1);
for i=1:1:no_site
    ok=~isnan(data_raw(:,i));
    d=data_raw(ok,i);
    dhat=data_recon(ok,i);
    r=d-dhat;
    var_r(i,1)=r'*r;
    Var_d(i,1)=d'*d;
end
var_explained_PCA=100*(1-sum(var_r)/sum(Var_d));
fprintf('variance explained PCA = %f%%\n', var_explained_PCA);
close(h);

