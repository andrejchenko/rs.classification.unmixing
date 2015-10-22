%% Use all training pixels as endmembers for each class: E = trainData
%  Enforce sparsity in the unmixing by using sparse unmixing method: sunsal 
%  which controls the sparsity with the lambda parameter

function allEndMembersSparseUnmixing()
    load('svmClassification_15_10_2015_40_train_60_test_10_cv');
    E = trainData';
    
    accuracies = [];
    x = [];
    for lambda = 0:0.1:1
        alphas = sunsal(E,testData','Positivity','yes','addone','no','lambda',lambda);
        %save alphaAllTrainData alphas
        %load alphaAllTrainData
        [Y,I] = max(alphas);

        alphaLabels = [];
        label = trainLabels(I);
        % for i = 1:size(I,2)
        %    label = trainLabels(I(i));
        %    alphaLabels = [alphaLabels; label];
        % end
        % EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
        EVAL_APHA = calcAccuracy(testLabels,label); 
        accuracies = [accuracies; EVAL_APHA(1)];
        x = [x; lambda];
    end
    save alphaAccuracy accuracies
    
    figure;
    plot(x,accuracies,'--gs','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor',[0.3,0.3,0.3]);
    stop = 1;
end

