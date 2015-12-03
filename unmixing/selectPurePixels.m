function [trainNeighData,trainNeighLabels,trainNeighMatrix] = selectPurePixels(trainNeighMatrix,trainNeighLabels)

numClasses = 16;
trainNeighData = [];
for i = 1:numClasses
        x = trainNeighMatrix{i}';
        dim = 8;
        %numit = 10000;
        numit = 1000;
        weighted = 0; %  weighted = true;
        score = MDPPI(x,dim,numit,weighted);  % take pixels only with high scores and use this endmember set in the sparse unmixing
        idx = find(score > 10);
        ind = find(score < 10);
        
        trainNeighMatrix{i} = x(:,idx)';
        trainNeighLabels(ind) = [];
        trainNeighData = [trainNeighData; trainNeighMatrix{i}];
end
stop = 1;
end
