function test_unmixing_fclsu()
[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();

avgOfmaxAcc = 0;
avgOfmaxAccBT = 0;
accUnmixing = 0;
    for a = 1:50
    [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands);
    
    
    %% Unmixing 
    % Using only the low number of labeled training pixels (5) to calculate the
    % mean endmember per class
    E = endMembers;
    alphas = FCLSU_fast(testData,E)';
    alphasT = alphas';
    alphaLabels = getLabels(alphasT);
    EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
    % abundance accuracy of 37.4%
    str = ['Unmixing accuracy using low number of normalized training pixels + their neighbours: ', num2str(EVAL_APHA(1)*100)];
    str
    
    accUnmixing = accUnmixing + EVAL_APHA(1)*100;
    end
    accUnmixing = accUnmixing/50;
    
    str = [' Average unmixing accuracy using low number of normalized training pixels + their neighbours: ', num2str(accUnmixing)];
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
