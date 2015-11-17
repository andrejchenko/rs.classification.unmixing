function lowNumPixForSVM_SimpleCombination

[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();

%% SVM training and classification with only a few number of pixels

% Selection of 5 training pixels per class, neighbours of these pixels and
% calculating the endmembers as a mean vector of the 5 training pixels per
% class
[trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands);

% SVM probabilistic classification
[predict_label, accuracy, prob_values] = svmClassification(trainData,trainLabels, testData, testLabels);
% svm classification accuracy of 36.4%
str = ['SVM accuracy: ', num2str(accuracy(1))];
str

%% Self Learning using Breaking Ties (BT) method

% Now we use the neighbouring pixels from each class as testing pixels and classify them in order to
% obtain thier (hard)label and the corresponding posterior probabilities 
load svm_model_16_10_2015
[predict_label_neigh, accuracy, post_prob_values] = libsvmpredict(testNeighLabels, neighData, model, '-b 1'); % run the SVM model on the test -  neighbouring data

% BT method
[candidates,candidateLabels,post_prob_values_refPerClass,candidates_Pix,candidates_LabPix,candidates_postProb] = createCandidates(trainLabels,neighData,predict_label_neigh,neighbours,post_prob_values);
info_candidates_PerClass = findMostInformative(candidates_Pix,candidates_LabPix,candidates_postProb); % D_u = info_candidates_PerClass

% Extend the training set of the SVM model using the D_u - most informative (neighbouring) pixels
% Re-train the SVM model with this extended set

[predict_labelE, accuracyE, prob_valuesE] = svmExtendedClassification(trainData,trainLabels, testData, testLabels,info_candidates_PerClass);
str = ['Extended SVM accuracy: ', num2str(accuracyE(1))];
str

%% Unmixing

E = endMembers;
alphas = FCLSU_fast(testData,E)'; 
alphasT = alphas';
alphaLabels = getLabels(alphasT);
EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
% abundance accuracy of 37.4%
str = ['Unmixing accuracy: ', num2str(EVAL_APHA(1)*100)];
str

%% Simple weighted combination of SVM classification and unmixing without BT
for w = 0:0.1:1
    comb_prob = w * prob_values + (1 - w) * alphasT;
    labels = getLabels(comb_prob);
    EVAL_COMB = calcAccuracy(testLabels,labels);
    str = ['w = ', num2str(w), ' accuracy of the combination without BT = ', num2str(EVAL_COMB(1)*100)];
    str
end

%% Simple weighted combination of SVM classification and unmixing including BT
for w = 0:0.1:1
    comb_prob = w * prob_valuesE + (1 - w) * alphasT;
    labels = getLabels(comb_prob);
    EVAL_COMB = calcAccuracy(testLabels,labels);
    str = ['w = ', num2str(w), ' accuracy of the combination including BT = ', num2str(EVAL_COMB(1)*100)];
    str
end
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