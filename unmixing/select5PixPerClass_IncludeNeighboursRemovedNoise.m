function [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighboursRemovedNoise(indian_pines,indian_pines_gt,numBands)

%% Find the indices of each class value from the ground truth indian pines
%  Store the indices for all classes in a classIndex variable
numClasses = 16;
for i = 1:(numClasses)
    classMatrix = indian_pines_gt(:,:) == i;  
    class{i} = classMatrix;
    [rowClass,colClass] = find(class{i} == 1);  
    classIndex{i} = [rowClass colClass];
end

for i = 1:(numClasses)
    len = size(classIndex{i},1);
    
    trainPixelsNum = 5;
    testPixelsNum = len - trainPixelsNum;
    
    index = randperm(len,trainPixelsNum +  testPixelsNum);
    
    trainIndex = index(1:trainPixelsNum);
    testIndex = index(trainPixelsNum + 1 : trainPixelsNum +  testPixelsNum);
   
    classTrainIndex{i} = [trainIndex'];
    classTestIndex{i} = [testIndex'];
    
end

trainLabels = [];
testLabels = [];
for i = 1:(numClasses)
    trainPixels = [];
    testPixels = [];
    for j = 1 : size(classTestIndex{i},1)
         testPix_x = classIndex{i}(classTestIndex{i}(j,1),1);
         testPix_y = classIndex{i}(classTestIndex{i}(j,1),2);
         testLabels = [testLabels; i];
         testPixels = [testPixels; testPix_x, testPix_y];
    end
    
    for j = 1:size(classTrainIndex{i},1)
        trainPix_x = classIndex{i}(classTrainIndex{i}(j,1),1);
        trainPix_y = classIndex{i}(classTrainIndex{i}(j,1),2);
         
        trainPixels = [trainPixels; trainPix_x, trainPix_y];
        trainLabels = [trainLabels; i];
    end
     
    trainPixIndClass{i} = trainPixels;
    testPixIndClass{i}  = testPixels;
end

for i = 1:(numClasses)
    trainMatrix{i} = [];
    testMatrix{i} = [];

    for j = 1: size(classTestIndex{i},1)
        testPixSpecVector = indian_pines(testPixIndClass{i}(j,1),testPixIndClass{i}(j,2),:);
        testPixSpecVector = reshape(testPixSpecVector, 1,numBands);
        testMatrix{i} = [testMatrix{i}; testPixSpecVector]; % each trainMatrix is N x d     
    end
    % Removing noise
    testMatrix{i} = removeNoise(testMatrix{i}');
    testMatrix{i} = testMatrix{i}';

    for j = 1:size(classTrainIndex{i},1)
        trainPixSpecVector = indian_pines(trainPixIndClass{i}(j,1),trainPixIndClass{i}(j,2),:);
        trainPixSpecVector = reshape(trainPixSpecVector, 1,numBands);
        trainMatrix{i} = [trainMatrix{i}; trainPixSpecVector]; % each trainMatrix is N x d
    end
    %Removing noise
     trainMatrix{i} = removeNoise(trainMatrix{i}');
     trainMatrix{i} = trainMatrix{i}';
end

% endMembers = endMembersCalc(trainMatrix); % endmembers from only 5 pixels per class,
% these 5 pixels are not normalized. Here I also have to use not normalized
% testData!

%getNeighbours method
[neighbours,neighboursData,testPixIndClass] = getNeighbours(trainPixIndClass,testPixIndClass,numClasses,indian_pines,classTrainIndex);

% Normalization of the training, testing and neighbourhood data
testLabels = [];
for i =1: numClasses
    testMatrix{i} = [];
    neighbourMatrix = [];
    for j = 1: size(testPixIndClass{i},1)
            testPixSpecVector = indian_pines(testPixIndClass{i}(j,1),testPixIndClass{i}(j,2),:);
            testPixSpecVector = reshape(testPixSpecVector, 1,numBands);
            testMatrix{i} = [testMatrix{i}; testPixSpecVector]; % each trainMatrix is N x d  
            testLabels = [testLabels; i];
    end
    %Removing noise
    testMatrix{i} = removeNoise(testMatrix{i}');
    testMatrix{i} = testMatrix{i}';
    
    % Normalisation of the training pixels
    trainMatrix{i} = normalize(trainMatrix{i});
    % Normalisation of the test data:
    testMatrix{i} = normalize(testMatrix{i});
    % Neighbour data should be normalized too:
    for j=1:size(neighboursData{i},2)  %-> 5 from 1x5 cell
        neighbourMatrix = [neighbourMatrix; neighboursData{i}{j}];
        neighboursData{i}{j} = [];
    end
    neighboursData{i} = neighbourMatrix;
    neighboursData{i} = removeNoise(neighboursData{i}');
    neighboursData{i} = neighboursData{i}';
    neighboursData{i} = normalize(neighboursData{i});
end

% endMembers = endMembersCalc(trainMatrix); % endmembers from only 5 normalized pixels per class

% save trainingAndTestMatrices_10_11_2015 trainMatrix testMatrix

% The trainMatrix and the neighboursData are already normalized, so we don't
% have to normalize here anything, we just append the neighboursData
% to the trainMatrix
trainData = [];
testData = [];
testNeighbourData = [];
neighData = [];
for i = 1:(numClasses)
    trainData = [trainData; trainMatrix{i}(:,:)];
    testData = [testData; testMatrix{i}(:,:)];
    neighMatrix{i} = neighboursData{i};
    neighData = [neighData;  neighMatrix{i}];
    trainMatrix_endMembers{i} = [trainMatrix{i}(:,:); neighMatrix{i}];
end
testNeighLabels = zeros(size(neighData,1),1);

%% Generate the endmembers including the neighbours
%  Having all the trainint pixels for each class we calculate the mean
%  pixel/spectral vector for each class and use these mean pixels as our
%  end members
%  endMembers = endMembersCalc(trainMatrix);

endMembers = endMembersCalc(trainMatrix_endMembers); % endmembers from 5 normalized pixels + their normalized neigbours

% endMembers = [];
% for i = 1:(numClasses)
%     classSpectrum = trainMatrix{i};
%     endMembers = [endMembers; mean(classSpectrum)];
%     meanSpectrum{i} = mean(classSpectrum);
% end
% % endMembers = endMembers';
% 
% endMembers = endMembersCalc(trainMatrix_endMembers);
% save endMembers_mean_10_11_2015 endMembers