function lowNumPixForSVM_PixelWiseCombination

%% SVM classification
[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();
[trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix ] = select5TrainingPixelsPerClass(indian_pines,indian_pines_gt,numBands);
% SVM probabilistic classification
[predict_label, accuracy, prob_values] = svmClassification(trainData,trainLabels, testData, testLabels);
% svm classification accuracy of 36%

%% Unmixing
% Pixel wise probability/abundance decision/selection
% Instead of using a fixed weight for the svm method and for the unmixing
% method, we go in more depth by looking at the probability value
% from the SVM and the abundance value for each pixel. We then select
% the higer value of those two as our end classification value and check if
% the classification accuracy is imroved or not. 
% The endmembers here are extracted using the mean of the training pixels from each class

%load('endMembers_mean_15_10_2015');
%load('svmClassification_15_10_2015_40_train_60_test_10_cv');
%load('unmixing_15_10_2015');
%alphasT = alphas';

E = endMembers;
alphas = FCLSU_fast(testData,E)'; 
alphasT = alphas';
alphaLabels = getLabels(alphasT);
EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
% abundance accuracy of 38%

comb_prob = [];
for i = 1: size(testData,1)
    if ((max(alphasT(i,:))) > (max(prob_values(i,:))))
        comb_prob = [comb_prob; max(alphasT(i,:))];
    else
        comb_prob = [comb_prob; max(prob_values(i,:))];
    end
end

labels = getLabels(comb_prob);
EVAL_COMB = calcAccuracy(testLabels,labels);
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