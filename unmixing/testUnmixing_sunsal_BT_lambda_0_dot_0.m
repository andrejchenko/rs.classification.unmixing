function testUnmixing_sunsal()
[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();

accUnmixing = 0;
    for a = 1:50
    %   Use the normalized train data and the normalized neighbouring data
    [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands);
    
    %[trainData,trainLabels] = assembleTrainDataAsMatrix(trainData, trainMatrix, neighMatrix, neighData);
    
    %% Use the BT - most informative (normalized) pixels as extension to the normalized trainData in the sunsal unmixing
    
    % Train the SVM model
    [predict_label, accuracy, prob_values] = svmClassification(trainData,trainLabels, testData, testLabels);
    % str = ['SVM accuracy: ', num2str(accuracy(1))];
    % str
    
    %% Self Learning using Breaking Ties (BT) method
    % Now we use the neighbouring pixels from each class as testing pixels and classify them in order to
    % obtain thier (hard)label and the corresponding posterior probabilities 
    load svm_model_30_11_2015
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
    
    % We only need the extended training data with BT to be used direclty
    % from the sunsal unmixing, we dont perform classification here
    %[predict_labelE, accuracyE, prob_valuesE] = svmExtendedClassification(trainData,trainLabels, testData, testLabels);
    %str = ['Extended SVM accuracy: ', num2str(accuracyE(1))];
    %str
    
    %% Sunsal Unmixing 
    E = trainData';
    accuracies = [];
    x = [];
    maxAcc = 0;
    maxLambda= -1;
%   for lambda = 0:0.1:1
    lambda = 0.0;
    alphas = sunsal(E,testData','Positivity','yes','addone','no','lambda',lambda);
    alphasT = alphas;
    [Y,I] = max(alphas);
    alphaLabels = [];
    label = trainLabels(I);
    EVAL_APHA = calcAccuracy(testLabels,label);
    str = ['Sunsal Unmixing accuracy: ', num2str(EVAL_APHA(1)*100)];
    str
    accuracies = [accuracies; EVAL_APHA(1)*100];
    x = [x; lambda];
    if(EVAL_APHA(1)*100 > maxAcc)
        maxAcc = EVAL_APHA(1)*100;
        maxLambda = lambda;
    end

    fileID = fopen('SparseUnmixing_with_BT_lambda_0_dot_0.txt','a');
    fprintf(fileID,'Iteration: %d, Sunsal unmixing accuracy: %4.3f with fixed lambda: %4.3f\n',a,EVAL_APHA(1)*100,lambda);
    fclose(fileID);
%   end
    accUnmixing = accUnmixing + EVAL_APHA(1)*100;
    end
    
accUnmixing = accUnmixing/50;  
str = [' Average unmixing accuracy using low number of normalized training pixels: ', num2str(accUnmixing)];
str
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
