function covSpace()
    load('endMembers_mean_16_10_2015');  
    load('svmClassification_16_10_2015_40_train_60_test_10_cv');
    load('trainingAndTestMatrices');
    E = endMembers';
    % Calculate the covariance matrices for all training pixels
    S = cov(trainData);
    % Project the endmemebrs to the covariance space
    projE = E * S;
    projE = projE';
    %Project the test data to the covariance space
    projTestData = testData * S;
    
    alphas = FCLSU_fast(projTestData,projE)'; 
    alphasT = alphas';
    alphaLabels = getLabels(alphasT);
    EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
    % abundance accuracy from 31%
    
    stop = 1;
end

%% Hard labeling using the maximal abundance value
function labels = getLabels(alphasT)
    maxArray = []; maxIndexArray = [];
    for i = 1:size(alphasT,1)
        maxEl = 0; maxIndex = 0;
        for j = 1:size(alphasT,2)
            if(alphasT(i,j) > maxEl)
                maxEl = alphasT(i,j);
                maxIndex = j;
            end
        end
        maxArray = [maxArray; maxEl];
        maxIndexArray = [maxIndexArray; maxIndex];
    end
    labels = maxIndexArray;
end