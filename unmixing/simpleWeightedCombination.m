%% Simple weighted combination of SVM classification and unmixing
function [maxAcc,maxW] = simpleWeightedCombination(prob_values,alphasT,testLabels)
    maxAcc = 0;
    maxW = 0;
    for w = 0:0.1:1
        comb_prob = w * prob_values + (1 - w) * alphasT;
        labels = getLabels(comb_prob);
        EVAL_COMB = calcAccuracy(testLabels,labels);
        str = ['w = ', num2str(w), ' Accuracy of the combination = ', num2str(EVAL_COMB(1)*100)];
        str
        if(EVAL_COMB(1)*100 > maxAcc)
            maxAcc = EVAL_COMB(1)*100;
            maxW = w;
        end
    end
end
