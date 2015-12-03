function test_unmixing_fclsu_BT()
[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();

accUnmixing = 0;
    for a = 1:50
    [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands);
    
    % Include the BT pixels as part of the trainData - trainMatrix from
    % where we can calculate the endmembers
    
    %% Use the BT - most informative (normalized) pixels
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
    numClasses = 16;
    for i=1:numClasses
        trainMatrix{i} = [];
        trainData = [trainData; info_candidates_PerClass{i}];
        labels = ones(size(info_candidates_PerClass{i},1),1);
        labels = labels*i;
        trainLabels = [trainLabels; labels];
        trainMatrix{i} = trainData;
    end
    
    % Calculate the endmembers using the trainData + neighbour + BT (most informative neighbouring pixels)
    endMembers = endMembersCalc(trainMatrix); 
    
    % We only need the extended training data with BT to be for calculation
    % of our endmembers, we dont perform classification here
    %[predict_labelE, accuracyE, prob_valuesE] = svmExtendedClassification(trainData,trainLabels, testData, testLabels);
    %str = ['Extended SVM accuracy: ', num2str(accuracyE(1))];
    %str
    
    %% FCLSU Unmixing 
    E = endMembers;
    alphas = FCLSU_fast(testData,E)';
    alphasT = alphas';
    alphaLabels = getLabels(alphasT);
    EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
    str = ['FCLSU Unmixing accuracy using low number of normalized training pixels + their neighbours + BT: ', num2str(EVAL_APHA(1)*100)];
    str
    
    accUnmixing = accUnmixing + EVAL_APHA(1)*100;
    
    fileID = fopen('FCLSU_Unmixing_with_BT.txt','a');
    fprintf(fileID,'Iteration: %d, FCLSU unmixing accuracy: %4.3f\n',a,EVAL_APHA(1)*100);
    fclose(fileID);
    
    end
    accUnmixing = accUnmixing/50;
    
    str = [' Average FCLSU unmixing accuracy using low number of normalized training pixels + their neighbours + BT: ', num2str(accUnmixing)];
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
