function out = FCLSU(HIM,M)
% Fully Constrained Linear Spectral Unmixing
% Perform a Linear least squares with nonnegativity constraints.
% --------------------------------------------------------------------
% Input:   HIM : hyperspectral image cube [nrows x ncols x nchannels]
%          M   : set of p endmembers [nchannels x p].
% 
% Output:  out : fractions [nrows x ncols x p] 
%
% 
% Copyright (2007) GRNPS group @ University of Extremadura, Spain. 


[ns,nl,nb] = size(HIM);
[l,p] = size(M);

Delta = 1/1000; % should be an small value

N = zeros(l+1,p);
N(1:l,1:p) = Delta*M;
N(l+1,:) = ones(1,p);
s = zeros(l+1,1);

OutputImage = zeros(ns,nl,p);

disp('Please wait...')
for i = 1:ns
    for j = 1:nl
        s(1:l) = Delta*squeeze(HIM(i,j,:));
        s(l+1) = 1;
        %Abundances = M73lsqnonneg(N,s);
        Abundances = M53lsqnonneg(N,s);
        OutputImage(i,j,:) = Abundances;
    end
 end
 disp('End')

out = OutputImage;