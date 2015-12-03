%% Simple weighted combination of SVM classification and unmixing
function [maxAcc,maxW] = pixelwiseCombination(prob_values,alphasT,testLabels,testData)
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
maxAcc = EVAL_COMB(1)*100;
maxW = '';
end
