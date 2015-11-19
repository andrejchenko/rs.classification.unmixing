% Normalisation of the training pixels, method 1
% 1. Find the mean(s) in all dimensions of the training pixels
% 2. Calculate the standard deviation:
%    sqrt((1/n)*sum_i[(pix - mean)(pix - mean)])
% 3. Divide our training pixels by the standard deviation

% function trainMatrix = normalize(trainMatrix)
%       meanVec = mean(trainMatrix); % 1 x 166
%       stdVecTrain = std(trainMatrix);   %  If trainMatrix{i} is a matrix whose columns are random variables-the dimensions (166) and whose rows are observations - pixels, then S is a row vector containing the standard deviations corresponding to each column/dimension.
%       trainMatrixNorm = bsxfun(@rdivide, trainMatrix,stdVecTrain);
%       trainMatrix = trainMatrixNorm;
% end


% Normalisation of the training pixels, method 2
% 1. dev = sqrt((v_1*v_1 + v_2*v_2 +...+ v_n*v_n)/n) or dev = sqrt((v_1*v_1 + v_2*v_2 +...+ v_n*v_n))
% 2. pix = v_i/dev;
% function trainMatrix = normalize(trainMatrix)
% tempTrainMatrix = [];
%       for j = 1: size(trainMatrix,1)
%           pix = trainMatrix(j,:);
%           sq_sum = 0;
%           for z = 1: size(pix,2)
%               sq_sum = sq_sum + pix(z)*pix(z);
%           end
%           %sq_sum = sq_sum/size(pix,2);
%           sqrt_sq_sum = sqrt(sq_sum);
%           pixNorm = pix./sqrt_sq_sum;
%           tempTrainMatrix = [tempTrainMatrix;pixNorm];
%       end
%       trainMatrix = tempTrainMatrix;
% end

% Normalisation of the training pixels
% 1. Find the mean per pixel: meanPix1 = (v_1+v_2+...+v_n)/n
% 2. (v_i - meanPix1)
% 3.  dev = sqrt((1/n) * (v_i-meanPix1)*(v_i-meanPix1))
% 4. pix = (v_i - meanPix1)/dev;

function trainMatrix = normalize(trainMatrix)
tempTrainMatrix = [];
      for j = 1: size(trainMatrix,1)
          pix = trainMatrix(j,:);
          meanPix = mean(pix);
          n = size(pix,2);
          sq_sum = 0;
          for z = 1: n
              %sq_sum = sq_sum + ((pix(z) - meanPix) * (pix(z)-meanPix));
              sq_sum = sq_sum + ((pix(z) - meanPix)*(pix(z) - meanPix));
          end
          dev = sqrt((1/n)*sq_sum);
          
          pixNorm = [];
          for z = 1: n
              pixNorm = [pixNorm; abs(pix(z) - meanPix) /dev];
          end  
          tempTrainMatrix = [tempTrainMatrix;pixNorm'];
      end 
      trainMatrix = tempTrainMatrix;
end