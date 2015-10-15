function main_fclsu_fast
%[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();
%procent = 0.4;
%[trainData,trainLabels, testData, testLabels,endMembers] = selectTrainingPixels(indian_pines,indian_pines_gt,procent,numBands);
%plot(endMembers);
% SVM probabilistic classification
%[predict_label, accuracy, prob_values] = svmClassification(trainData,trainLabels, testData, testLabels);

% Unmixing
%alphas = FCLSU_fast(testData,endMembers)'; % SLOW

load('svmClassification_15_10_2015_40_train_60_test_10_cv_endmembers');
load('alphas_unmixing_15_10_2015_40_train_60_test');
alphasT = alphas';
alphaLabels = getLabels(alphasT);
EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
EVAL_SVM = calcAccuracy(testLabels,predict_label);

w = 0.8; % weight the svm classification and unmixing method: w*svm + (1 - w)*abundance

w_prob_values = w * prob_values;
w_alphasT = (1 - w) * alphasT;
comb_prob = w * prob_values + (1 - w) * alphasT;
labels = getLabels(comb_prob);

EVAL_COMB = calcAccuracy(testLabels,labels);

for w = 0:0.1:1
    comb_prob = w * prob_values + (1 - w) * alphasT;
    labels = getLabels(comb_prob);
    EVAL_COMB = calcAccuracy(testLabels,labels);
    str = ['w = ', num2str(w), ' accuracy of the combination = ', num2str(EVAL_COMB(1))];
    str
end


x = 3;

%% Checking the abundance values and svm probabilistic classification values accuracy
% load('svmClassification_15_10_2015_40_train_60_test_10_cv_endmembers');
% load('alphas_unmixing_15_10_2015_40_train_60_test');
% alphasT = alphas';
% alphaLabels = getLabels(alphasT);
% EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
% EVAL_SVM = calcAccuracy(testLabels,predict_label);

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