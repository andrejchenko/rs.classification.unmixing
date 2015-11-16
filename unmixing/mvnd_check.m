% Classes: 1, 7, 9 have to few training pixels. Even if we rearrange
% and transfer most of the test pixels as training pixels, the num. of
% rows (pixels) < num of dimensions. So we discard these 3 classes from
% our analysis. Classes 4 and 13 have also num. of rows (pixels) < num
% of dimensions, but we could increase this trainning pixel number by
% adding some of our testing pixels to out training set so that we can
% reach: num. of rows (pixels) > num. of dimensions

% Now using training pixels from all classes except 1, 7, 9 we check
% whether these training pixels from each class follow a Multivariate
% Normal Distribution.

function mvnd_check()
    
     [trainMatrixRe,testMatrixRe,trainLabelsRe,testLabelsRe,trainDataRe,testDataRe,means] = trainDataModify();
     % Calculate the distances of each training pixel in a specific class
     % to its mean

     for i = 1:15
         % for i = 1:size(trainMatrixRe,2)
         dist = [];
         chiAlphaInputs = [];
         n = size(trainMatrixRe{i},1);
         if((i==1)||(i==7) ||(i==9))
             ;
         else
             C = cov(trainMatrixRe{i});
             for j = 1:n
                 x = trainMatrixRe{i}(j,:)';
                 d = sqrt((x-means(:,i))'*inv(C)*(x-means(:,i)));
                 dist = [dist; d*d];
                 
                 index = (n-j+(1/2))/n;
                 chiAlphaInputs = [chiAlphaInputs; index];
             end
         end
         
         % sorting the distance vector
         sortedDist = sort(dist,'ascend');
         %sortedDist = sort(dist,'descend');

         %chiValues = chi2pdf(sortedDist,size(trainMatrixRe{i},1));
         % chiValues = chi2pdf(chiAlphaInputs,n);
          chiValues = chi2pdf(chiAlphaInputs,166);
         % chiValues = chi2cdf(chiAlphaInputs,166);
         % chiSqValues = chiValues.*chiValues;
         % chiValues = chi2pdf(sortedDist,166);
         if(size(sortedDist,1)==0)
             ;
         else
             figure;
             plot(chiValues,sortedDist, 'r-');
             xlabel('chi square values') % x-axis label
             ylabel('sorted distances') % y-axis label
             axis([0,max(chiValues),0,max(sortedDist)])
         stop = 1;
     end
    stop = 1;
end
