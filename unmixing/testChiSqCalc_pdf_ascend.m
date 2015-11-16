function testChiSqCalc_pdf_ascend()
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
    
    % sortedDist = sort(dist,'ascend');
     sortedDist = sort(dist,'ascend');
     chiValues = chi2pdf(chiAlphaInputs,size(vec,1));
    % chiValues = chi2cdf(chiAlphaInputs,size(vec,1));
    % chiSqValues = chiValues.*chiValues;
    
    % hist(vec);
    % chiValues = chi2pdf(sortedDist,1);
    % chiValues = chi2pdf(sortedDist,166);
    figure;
    % plot(chiSqValues,sortedDist, 'r-');
    plot(chiValues,sortedDist, 'r-');
    xlabel('chi square values') % x-axis label
    ylabel('sorted distances') % y-axis label
    stop = 1;
end