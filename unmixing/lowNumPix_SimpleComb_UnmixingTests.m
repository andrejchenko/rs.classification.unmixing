function lowNumPixForSVM_SimpleCombination

[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();

%% SVM training and classification with only a few number of pixels

% Selection of 5 training pixels per class, neighbours of these pixels and
% calculating the endmembers as a mean vector of the 5 training pixels per
% class
avgUnmixingAcc = 0;
avgOfmaxAcc = 0;
avgOfmaxAccBT = 0;

for a = 1:50
[trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands);

initialTrainData = trainData;
initialTrainMatrix = trainMatrix;
initialNeighMatrix = neighMatrix;
initialNeighData = neighData;

% SVM probabilistic classification
% Run the SVM classification 100 times in order to calculate the average SVM
% accuracy with the normalized data

% averageAccuracy = 0;
% for i =1:100
%     [predict_label, accuracy, prob_values] = svmClassification(trainData,trainLabels, testData, testLabels);
%     % svm classification accuracy of 36.4%
%     averageAccuracy = averageAccuracy + accuracy(1);
%     str = ['Iteration', num2str(i),', SVM accuracy: ', num2str(accuracy(1))];
%     str
% end
% averageAccuracy = averageAccuracy/100;
% str = ['Average SVM accuracy after 10 loops: ', num2str(averageAccuracy)];
% str
% avgOfmaxAcc = 0;
% avgOfmaxAccBT = 0;
%for a = 1:50
    [predict_label, accuracy, prob_values] = svmClassification(trainData,trainLabels, testData, testLabels);
    str = ['SVM accuracy: ', num2str(accuracy(1))];
    str

    %% Self Learning using Breaking Ties (BT) method

    % Now we use the neighbouring pixels from each class as testing pixels and classify them in order to
    % obtain thier (hard)label and the corresponding posterior probabilities 
    load svm_model_27_11_2015
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
% 
    [predict_labelE, accuracyE, prob_valuesE] = svmExtendedClassification(trainData,trainLabels, testData, testLabels);
    str = ['Extended SVM accuracy: ', num2str(accuracyE(1))];
    str

    %% Unmixing 
    % Using only the low number of labeled training pixels to calculate the
    % mean end member
    % 1. Accuracy test using FCLSU when testData and endMembers are normalized
%     E = endMembers;
%     alphas = FCLSU_fast(testData,E)'; % at the moment testData and the mean endmembers are normalized
%     alphasT = alphas';
%     alphaLabels = getLabels(alphasT);
%     EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
%     % abundance accuracy of 37.4%
%     str = ['Unmixing accuracy when testData and endMembers are normalized: ', num2str(EVAL_APHA(1)*100)];
%     str
%     avgUnmixingAcc = avgUnmixingAcc + EVAL_APHA(1)*100;
    
    % 2. Accuracy test using sparse unmixing: sunsal when testData and endMembers are normalized
    
    [trainData,trainLabels] = assembleTrainDataAsMatrix(initialTrainData, initialTrainMatrix, initialNeighMatrix, initialNeighData);
    
    E = trainData';
    accuracies = [];
    x = [];
    maxAcc = 0;
    maxLambda= -1;
%     for lambda = 0:0.1:1
        lambda = 0.2;
        alphas = sunsal(E,testData','Positivity','yes','addone','no','lambda',lambda);
        alphasT = alphas;
        [Y,I] = max(alphas);
        alphaLabels = [];
        label = trainLabels(I);
        EVAL_APHA = calcAccuracy(testLabels,label); 
        % abundance accuracy of ???
        str = ['Unmixing accuracy using sparse unmixing when testData and endMembers are normalized: ', num2str(EVAL_APHA(1)*100)];
        str
        accuracies = [accuracies; EVAL_APHA(1)*100];
        x = [x; lambda];
        if(EVAL_APHA(1)*100 > maxAcc)
            maxAcc = EVAL_APHA(1)*100;
            maxLambda = lambda;
        end
        
%     end
    
%     avgUnmixingAcc = avgUnmixingAcc + maxAcc;
%     fileID = fopen('sparseUnmixing.txt','a');
%     fprintf(fileID,'Iteration: %d, Max accuracy of Unmixing (on normalized data): %4.3f, with lamda: %4.3f\n',a,maxAcc,maxLambda);
%     fclose(fileID);
    
    % 3. Accuracy test when testData and endMembers are not normalized
%     E = endMembers;
%     alphas = FCLSU_fast(testData,E)';
%     alphasT = alphas';
%     alphaLabels = getLabels(alphasT);
%     EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
%     % abundance accuracy of 37.4%
%     str = ['Unmixing accuracy when testData and endMembers are not normalized: ', num2str(EVAL_APHA(1)*100)];
%     str
    
    % Re-Calculate the endmembers using not only the 5 pixels per class but the
    % extended training set - D_u - the unlabled pixels as well, then the
    % endMembers_Ext = getEndmembers(trainMatrix,numClasses);
    % Using the extended set of training pixels to calculate the mean endmember
    % The Unmixing accuracy dropped to 7-8%
    % E = endMembers_Ext;
    % alphas = FCLSU_fast(testData,E)'; 
    % alphasT = alphas';
    % alphaLabels = getLabels(alphasT);
    % EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
    % % abundance accuracy of 37.4%
    % str = ['Unmixing accuracy using the extended training pixels: ', num2str(EVAL_APHA(1)*100)];
    % str

    alphasT = sumAbundancesPerClass(trainData, trainMatrix,alphas);
    
    
    %% Simple weighted combination of SVM classification and unmixing without BT
    maxAcc = 0;
    maxW = 0;
    for w = 0:0.1:1
        comb_prob = w * prob_values + (1 - w) * alphasT;
        labels = getLabels(comb_prob);
        EVAL_COMB = calcAccuracy(testLabels,labels);
        str = ['w = ', num2str(w), ' accuracy of the combination without BT = ', num2str(EVAL_COMB(1)*100)];
        str

        if(EVAL_COMB(1)*100 > maxAcc)
            maxAcc = EVAL_COMB(1)*100;
            maxW = w;
        end
    end

    fileID = fopen('SparseUnmixing_lambda_0_dot_2_withoutBT.txt','a');
    fprintf(fileID,'Iteration: %d, Accuracy of combined SVM +Sparse  Unmixing (on normalized data): %4.3f with weight: %4.3f\n',a,maxAcc,maxW);
    fclose(fileID);
    avgOfmaxAcc = avgOfmaxAcc + maxAcc;

    %% Simple weighted combination of SVM classification and unmixing including BT
    maxAcc = 0;
    maxW = 0;
    for w = 0:0.1:1
        comb_prob = w * prob_valuesE + (1 - w) * alphasT;
        labels = getLabels(comb_prob);
        EVAL_COMB = calcAccuracy(testLabels,labels);
        str = ['w = ', num2str(w), ' Accuracy of the combination including BT = ', num2str(EVAL_COMB(1)*100)];
        str
        if(EVAL_COMB(1)*100 > maxAcc)
            maxAcc = EVAL_COMB(1)*100;
            maxW = w;
        end
    end

    fileID = fopen('SparseUnmixing_lambda_0_dot_2_includeBT.txt','a');
    fprintf(fileID,'Iteration: %d, Accuracy of combined SVM + BT + Sparse Unmixing (on normalized data): %4.3f, with weight: %4.3f\n',a,maxAcc,maxW);
    fclose(fileID);
    avgOfmaxAccBT = avgOfmaxAccBT + maxAcc;
    stop = 1;
end
avgOfmaxAcc = avgOfmaxAcc/50;
fileID = fopen('SparseUnmixing_lambda_0_dot_2_withoutBT.txt','a');
fprintf(fileID,'Average accuracy: %4.3f\n',avgOfmaxAcc);
fclose(fileID);
% 
avgOfmaxAccBT = avgOfmaxAccBT/50;
fileID = fopen('SparseUnmixing_lambda_0_dot_2_includeBT.txt','a');
fprintf(fileID,'Average accuracy: %4.3f\n',avgOfmaxAccBT);
fclose(fileID);

% avgUnmixingAcc = avgUnmixingAcc/50;
% str = ['Average Unmixing accuracy on normalized data is: ', num2str(avgUnmixingAcc)];
% str

% avgUnmixingAcc = avgUnmixingAcc/50;
% 
% fileID = fopen('sparseUnmixing.txt','a');
% fprintf(fileID,'Average accuracy: %4.3f\n',avgUnmixingAcc);
% fclose(fileID);

stop2 = 2;
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