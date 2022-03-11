function [coeff, score, latent, explained, mu] = pca_als(data_raw,num_pc,is_Centered,Options)
% 
% Description: Performing PCA decomposition using the Matlab built-in algorithm (als) for missing data
% 
% Input:
%   data_raw         Raw observation data
%   num_pc           Number of selected PCs 
%   is_Centered      Centralized observation matrix (true or false)
%   Options          Options for als algorithm, including four parameters:
%                    'Display' - Level of display output.  Choices are 'off' (the default), 'final', and 'iter'.
%                    'MaxIter' - Maximum number of steps allowed. The default is 1000. Unlike in optimization settings, reaching MaxIter is regarded as convergence.
%                    'TolFun' - Positive number giving the termination tolerance for the cost function.  The default is 1e-6.
%                    'TolX' - Positive number giving the convergence threshold for relative change in the elements of L and R.The default is 1e-6.
% Output:
%   coeff            Spatial functions
%   score            Temporal fucntions
%   latent           Variance contribution of selected PCs to raw GNSS data
%   explained        Variance contribution of each PC to the filtered data
%   mu               Reconstructed GNSS data
% 
% Author: Zhongshan Jiang
% Date: 11/03/2022 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

x = data_raw;
vNumComponents = num_pc;
vCentered = is_Centered;
opts = Options;

[n, p] = size(x);
vVariableWeights=ones(1,p);
vWeights=ones(1,n);

% Alternating Least Square Algorithm
vNumComponents = min([vNumComponents,n-vCentered,p]);  % ALS always return economy sized outputs

s0 = randn(n,vNumComponents,'like',x);
c0 = randn(p,vNumComponents,'like',x);
[score,coeff,mu,latent]=alsmfm(x,vNumComponents,'L0',s0,'R0',c0,...
    'Weights',vWeights,'VariableWeights',vVariableWeights,...
    'Orthonormal',true,'Centered',vCentered,'Options',opts); % Matlab built-in function (alsmf)

% Calcuate the percentage of the total variance explained by each principal component.
if nargout > 3
    explained = 100*latent/sum(latent);
end

% Enforce a sign convention on the coefficients -- the largest element in each column will have a positive sign.
[~,maxind] = max(abs(coeff), [], 1);
[d1, d2] = size(coeff);
colsign = sign(coeff(maxind + (0:d1:(d2-1)*d1)));
coeff = coeff.*colsign;
if nargout > 1
    score = score.*colsign; % scores = score
end

end 


