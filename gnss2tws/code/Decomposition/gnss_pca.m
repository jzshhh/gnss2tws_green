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
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

%% Implementing PCA decomposition, algorithm 'als'
h=msgbox('Implement PCA decomposition, algorithm: ''als'', please wait!');
opt = statset('pca'); opt.MaxIter = 1000; opt.Display = 'iter';
[coeff,score,latent,tsquared,explained,mu] = pca(data_raw,'algorithm','als','Centered','off','NumComponents',num_pc,'Options',opt);
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

