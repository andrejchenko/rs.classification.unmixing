function lowNumPixForSVM_SimpleCombination

%% SVM classification
[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();
% [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix ] = select5TrainingPixelsPerClass(indian_pines,indian_pines_gt,numBands);

[trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands);

% SVM probabilistic classification
[predict_label, accuracy, prob_values] = svmClassification(trainData,trainLabels, testData, testLabels);
% svm classification accuracy of 36.4%
str = ['SVM accuracy: ', num2str(accuracy(1))];
str

% Now use the neighbouring pixels for each class as testing pixels and classify them in order to be able to
% obtain a label for them and their posterior probabilities 
load svm_model_16_10_2015
[predict_label_neigh, accuracy, post_prob_values] = libsvmpredict(testNeighLabels, neighData, model, '-b 1'); % run the SVM model on the test data

[candidates,candidateLabels,post_prob_values_refPerClass,candidates_Pix,candidates_LabPix,candidates_postProb] = createCandidates(trainLabels,neighData,predict_label_neigh,neighbours,post_prob_values);

findMostInformative(candidates_Pix,candidates_LabPix,candidates_postProb);


%% Unmixing
% Simple weighted combination of SVM classification and unmixing

E = endMembers;
alphas = FCLSU_fast(testData,E)'; 
alphasT = alphas';
alphaLabels = getLabels(alphasT);
EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
% abundance accuracy of 37.4%
str = ['Unmixing accuracy: ', num2str(EVAL_APHA(1)*100)];
str

for w = 0:0.1:1
    comb_prob = w * prob_values + (1 - w) * alphasT;
    labels = getLabels(comb_prob);
    EVAL_COMB = calcAccuracy(testLabels,labels);
    str = ['w = ', num2str(w), ' accuracy of the combination = ', num2str(EVAL_COMB(1)*100)];
    str
end
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