function combineSVM_BT_Sunsal()

[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();
avgOfmaxAcc = 0;
for a = 1:50 % to obtain an average accuracy
    
    % Selection of 5 training pixels per class including their neighbours
    [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands);

    % Combine the 5 pixels per class with their neighbours to be used by
    % the sunsal sparse unmixing method
    [trainNeighData,trainNeighLabels,trainNeighMatrix] = assembleTrainData(trainData, trainMatrix, neighMatrix, neighData);
    
    %% SVM training and (probabilistic) classification with only a few number of pixels - 5 per class
    [predict_label, accuracy, prob_values] = svmClassification(trainData,trainLabels, testData, testLabels);
    str = ['SVM accuracy: ', num2str(accuracy(1))];
    str
    
    %% Self Learning using Breaking Ties (BT) method
    % Now we use the neighbouring pixels from each class as testing pixels and classify them in order to
    % obtain thier (hard)label and the corresponding posterior probabilities 
    load svm_model_01_12_2015
    [predict_label_neigh, accuracy, post_prob_values] = libsvmpredict(testNeighLabels, neighData, model, '-b 1'); % run the SVM model on the test -  neighbouring data
    
    % BT method
    [candidates,candidateLabels,post_prob_values_refPerClass,candidates_Pix,candidates_LabPix,candidates_postProb] = createCandidates(trainLabels,neighData,predict_label_neigh,neighbours,post_prob_values);
    info_candidates_PerClass = findMostInformative(candidates_Pix,candidates_LabPix,candidates_postProb); % D_u = info_candidates_PerClass

    % Extend the training set of the SVM model using the D_u - most informative (neighbouring) pixels
    % Re-train the SVM model with this extended set
    numClasses = 16;
    for i=1:numClasses
        trainMatrix{i} = [];
        trainData = [trainData; info_candidates_PerClass{i}];
        labels = ones(size(info_candidates_PerClass{i},1),1);
        labels = labels*i;
        trainLabels = [trainLabels; labels];
        trainMatrix{i} = trainData;
    end
    
    [predict_labelE, accuracyE, prob_valuesE] = svmExtendedClassification(trainData,trainLabels, testData, testLabels);
    str = ['Extended SVM accuracy: ', num2str(accuracyE(1))];
    str
    
    %% Sunsal unmixing
    lambda = 0.9;
    alphas = sunsalUnmixing(trainNeighData,trainNeighLabels,testData,testLabels, lambda);
    
    alphasPerClass = maxAbundancesPerClass(trainNeighData,trainNeighMatrix,alphas);
    
    %[maxAcc,maxW] = simpleWeightedCombination(prob_valuesE,alphasPerClass,testLabels);
    [maxAcc,maxW] = simpleWeighting(prob_valuesE,alphasPerClass,testLabels);
    
    saveInterResultsToFile(a,maxAcc,maxW);
    avgOfmaxAcc = avgOfmaxAcc + maxAcc;
end
    avgOfmaxAcc = avgOfmaxAcc/50;
    saveAverageResultToFile(avgOfmaxAcc);
end