function testChiSqCalc()
    % vec = normrnd(1:571,1./(1:571))';
    vec = normrnd(0,1,[1 571]);
    meanVal = mean(vec);
    varVal = var(vec);
    C = cov(vec);
    V = varVal;
    dist = [];
    chiAlphaInputs = [];
    n = size(vec,2);
    for i = 1: n
        x = vec(i);
        m = meanVal;
        d = sqrt((x-m)'*inv(V)*(x-m));
        dist = [dist; d*d];
        index = (n-i+(1/2))/n;
        chiAlphaInputs = [chiAlphaInputs; index];
    end
    
    sortedDist = sort(dist,'ascend');
    chiValues = chi2pdf(chiAlphaInputs,size(vec,1));
    % hist(vec);
    % chiValues = chi2pdf(sortedDist,1);
    % chiValues = chi2pdf(sortedDist,166);
    figure;
    plot(chiValues,sortedDist,'r-');
    stop = 1;
end