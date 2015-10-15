
[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();
procent = 0.4;
[trainData,trainLabels, testData, testLabels,endMembers] = selectTrainingPixels(indian_pines,indian_pines_gt,procent,numBands);
plot(endMembers);
% SVM probabilistic classification
[predict_label, accuracy, prob_values] = svmClassification(trainData,trainLabels, testData, testLabels);


% Unmixing
alphas = FCLSU_fast(testData,endMembers)'; % SLOW
x = 3;



