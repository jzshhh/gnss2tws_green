function s=inversion_type(A,d,inversion_flag)
%
% Description: Perform inversion for EWH estimates
%
% Input:
%   A              Coefficient matrix
%   d              Observation vector
%   inversion_flag Inversion type
% Output:
%   s               Estimates of EWH 
%
% Author:       Zhongshan Jiang        
% Organization: Southwest Jiaotong University 
% E-mail:       jzshhh@my.swjtu.edu.cn
% Date:         28/10/2021

switch(inversion_flag)
    case 'LS'
        disp('Classical least-squares inversion');
        s=A\d;
    case  'pinv'  
        disp('Pseudo inverse used');
        s=pinv(A) * d;
    case 'lsqlin'
        disp('Constrained linear least-squares inversion');
        options = optimset('LargeScale','on','DiffMaxChange',1e-1,'DiffMinChange',1e-9,'TolCon',1e-9,'TolFun',1e-9,'TolPCG',1e-9,'TolX',1e-9,'MaxIter',1e9,'MaxPCGIter',1e9,'Display','off');
        % lb=  -1.00*ones(size(A,2),1); ub= 1.00*ones(size(A,2),1); % using boundary constraints for model parameters
        lb=[]; ub=[]; 
        [s,resnorm]=lsqlin(A,d,[],[],[],[],lb,ub,[],options);
end
end
