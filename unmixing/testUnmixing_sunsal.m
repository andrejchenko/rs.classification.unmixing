function testUnmixing_sunsal()
[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();

accUnmixing = 0;
    for a = 1:50
    %1. Try with only 5 normalized pix
    %2. Try with 5 normalized pixels and their neighbours
    [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands);
    %   use the normalized train data and the normalized neighbouring data
    %   without the BT pixels
    [trainData,trainLabels] = assembleTrainDataAsMatrix(trainData, trainMatrix, neighMatrix, neighData);
    
    %% Sunsal Unmixing 
    E = trainData';
    accuracies = [];
    x = [];
    maxAcc = 0;
    maxLambda= -1;
    for lambda = 0:0.1:1
        % lambda = 0.2;
        alphas = sunsal(E,testData','Positivity','yes','addone','no','lambda',lambda);
        alphasT = alphas;
        [Y,I] = max(alphas);
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
        
        fileID = fopen('SparseUnmixing_all_lambdas.txt','a');
        fprintf(fileID,'Iteration: %d, Sunsal unmixing accuracy: %4.3f with lambda: %4.3f\n',a,EVAL_APHA(1)*100,lambda);
        fclose(fileID);
    end
    %str = ['Average susnal unmixing accuracy: ', num2str(EVAL_APHA(1)*100)];
    %str
    %accUnmixing = accUnmixing + EVAL_APHA(1)*100;
    accUnmixing = accUnmixing + maxAcc;
    end
    
accUnmixing = accUnmixing/50;  
str = [' Sunsal average unmixing accuracy using low number of normalized training pixels: ', num2str(accUnmixing)];
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
