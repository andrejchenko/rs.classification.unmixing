function pcaSpace()
    load('svmClassification_16_10_2015_40_train_60_test_10_cv');
    load('trainingAndTestMatrices');
    
    %[C,S] = pca(trainData); % S is a matrix with the training pixels projected to the PCA space
    E = [];
    for i=1:15
        [C,S] = pca(trainMatrix{i});
        m = mean(S);
        E = [E m];
    end
    stop = 1;
%     alphas = FCLSU_fast(projTestData,E)'; 
%     alphasT = alphas';
%     alphaLabels = getLabels(alphasT);
%     EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
    
    %apply PCA on the training pixels
end