function main_fclsu_fast

%% SVM classification
%[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();
%procent = 0.4;
%[trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix ] = selectTrainingPixels(indian_pines,indian_pines_gt,procent,numBands);
%plot(endMembers);
% SVM probabilistic classification
%[predict_label, accuracy, prob_values] = svmClassification(trainData,trainLabels, testData, testLabels);

%% Unmixing

% 1st Option. Using the SVs from the training model from which we extract the
% endmembers - by taking the mean SV per class -> abundance accuracy is
% lower - 39 percent
% load('svm_model_15_10_2015');
% load('svmClassification_15_10_2015_40_train_60_test_10_cv');

% endMembers = selectSVTrainingData(model,trainData,trainLabels);
% alphas = FCLSU_fast(testData,endMembers)'; % SLOW
% alphasT = alphas';
% alphaLabels = getLabels(alphasT);
% EVAL_APHA = calcAccuracy(testLabels,alphaLabels);


% 2nd Option. Pixel wise probability/abundance decision/selection
% Instead of using a fixed weight for the svm method and for the unmixing
% method, we go in more depth by having a look at the probability value
% from the SVM and the abundance value for each pixel. We then select
% the higer value of those two as our end classification value and check if
% the classification accuracy is imroved or not. The result showed us that
% the classification results are worse...
% The endmembers here are extracted using the mean
% of the training pixels from each class

%load('endMembers_mean_15_10_2015');
%load('svmClassification_15_10_2015_40_train_60_test_10_cv');
%load('unmixing_15_10_2015');

%alphasT = alphas';

% comb_prob = [];
% for i = 1: size(testData,1)
%     if ((max(alphasT(i,:))) > (max(prob_values(i,:))))
%         comb_prob = [comb_prob; max(alphasT(i,:))];
%     else
%         comb_prob = [comb_prob; max(prob_values(i,:))];
%     end
% end
% 
% labels = getLabels(comb_prob);
% EVAL_COMB = calcAccuracy(testLabels,labels);

%% 3rd Option. Use Robs extraction of endmembers method:
% extract_class_endmembers.m to improve the unmixing accuracy first
% Then use these better fitting class endmembers as input to FCLSU_fast
% unmixing method and see wheter the abbundance accuracy is increasing or
% not. Afterwards try to combine the abundance and svm probability
% values per pixel and see if the final classification accuracy is
% improved.

load('trainingAndTestMatrices');
load('svmClassification_16_10_2015_40_train_60_test_10_cv');
load('svm_model_15_10_2015');
% we now include all the data: training + testing data for endmember
% extraction
for i = 1: model.nr_class
    L{i} = trainMatrix{i};
    L{i} = [L{i}; testMatrix{i}];
    L{i} = L{i}';
end

% We need dxN as input
[E,I]=extract_class_endmembers(L);
alphas = FCLSU_fast(testData,E)'; 
alphasT = alphas';
alphaLabels = getLabels(alphasT);
EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
% using both the trainMatrix and testMatrix to extract the endmembers we get 35% abundance accuracy...

% EVAL_SVM = calcAccuracy(testLabels,predict_label);
% 
% w = 0.8; % weight the svm classification and unmixing method: w*svm + (1 - w)*abundance
% 
% w_prob_values = w * prob_values;
% w_alphasT = (1 - w) * alphasT;
% comb_prob = w * prob_values + (1 - w) * alphasT;
% labels = getLabels(comb_prob);
% 
% EVAL_COMB = calcAccuracy(testLabels,labels);
% 
% for w = 0:0.1:1
%     comb_prob = w * prob_values + (1 - w) * alphasT;
%     labels = getLabels(comb_prob);
%     EVAL_COMB = calcAccuracy(testLabels,labels);
%     str = ['w = ', num2str(w), ' accuracy of the combination = ', num2str(EVAL_COMB(1))];
%     str
% end

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