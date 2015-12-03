function alphasNew = sumAbundancesPerClass(trainData, trainMatrix,alphas) 
numClasses = 16;
alphasNew = [];
    for i=1:numClasses
        if (i == 1)
            alphasPerClass = alphas(1:size(trainMatrix{i},1),:);
            classSum = sum(alphasPerClass);
            alphasNew = [alphasNew;classSum];
        else
            alphasPerClass = alphas(size(trainMatrix{i-1},1)+1:size(trainMatrix{i-1},1) + size(trainMatrix{i},1),:);
            classSum = sum(alphasPerClass);
            alphasNew = [alphasNew;classSum];
        end
    end
alphasNew = alphasNew';
end
