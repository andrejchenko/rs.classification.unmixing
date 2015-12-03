function alphasNew = maxAbundancesPerClass(trainData, trainMatrix,alphas) 
% TO DO change the method to take max abundance per class into account!!!
numClasses = 16;
alphasNew = [];
    for i=1:numClasses
        if (i == 1)
            alphasPerClass = alphas(1:size(trainMatrix{i},1),:);
            classMax = max(alphasPerClass);
            alphasNew = [alphasNew;classMax];
        else
            alphasPerClass = alphas(size(trainMatrix{i-1},1)+1:size(trainMatrix{i-1},1) + size(trainMatrix{i},1),:);
            classMax = max(alphasPerClass);
            alphasNew = [alphasNew;classMax];
        end
    end
alphasNew = alphasNew';
end
