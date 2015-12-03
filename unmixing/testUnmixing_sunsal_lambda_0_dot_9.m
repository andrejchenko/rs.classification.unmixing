function testUnmixing_sunsal_lambda_0_dot_9()
[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();

accUnmixing = 0;
    for a = 1:50
    % Use the normalized train data and the normalized neighbouring data
    % without the BT pixels
    [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands);
    [trainData,trainLabels] = assembleTrainDataAsMatrix(trainData, trainMatrix, neighMatrix, neighData);
    
    %% Sunsal Unmixing 
    E = trainData';
    accuracies = [];
    x = [];
    maxAcc = 0;
    maxLambda= -1;
%   for lambda = 0:0.1:1
    lambda = 0.9;
    alphas = sunsal(E,testData','Positivity','yes','addone','no','lambda',lambda);
    alphasT = alphas;
    [Y,I] = max(alphas); % Hard labeling using the maximal abundance value    alphaLabels = getLabels(alphasT);
                                                                            % EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
    alphaLabels = [];
    label = trainLabels(I);
    EVAL_APHA = calcAccuracy(testLabels,label);
    str = ['Sunsal Unmixing accuracy: ', num2str(EVAL_APHA(1)*100)];
    str
    accuracies = [accuracies; EVAL_APHA(1)*100];
    x = [x; lambda];
    if(EVAL_APHA(1)*100 > maxAcc)
        maxAcc = EVAL_APHA(1)*100;
        maxLambda = lambda;
    end
%   end
    str = ['Sunsal unmixing accuracy: ', num2str(EVAL_APHA(1)*100)];
    str
    accUnmixing = accUnmixing + EVAL_APHA(1)*100;
    
    fileID = fopen('SparseUnmixing_lambda_0_dot_9.txt','a');
    fprintf(fileID,'Iteration: %d, Sunsal unmixing accuracy: %4.3f with fixed lambda: %4.3f\n',a,EVAL_APHA(1)*100,lambda);
    fclose(fileID);
    end
    
accUnmixing = accUnmixing/50;  
str = [' Average sunsal unmixing accuracy: ', num2str(accUnmixing)];
str



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
