function [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands)

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

    for j = 1:size(classTrainIndex{i},1)
        trainPixSpecVector = indian_pines(trainPixIndClass{i}(j,1),trainPixIndClass{i}(j,2),:);
        trainPixSpecVector = reshape(trainPixSpecVector, 1,numBands);
        trainMatrix{i} = [trainMatrix{i}; trainPixSpecVector]; % each trainMatrix is N x d
    end
end

%getNeighbours method
[neighbours,neighboursData] = getNeighbours(trainPixIndClass,testPixIndClass,numClasses,indian_pines,classTrainIndex);

% save trainingAndTestMatrices_10_11_2015 trainMatrix testMatrix
trainData = [];
testData = [];
testNeighbourData = [];
neighData = [];
for i = 1:(numClasses)
    trainData = [trainData; trainMatrix{i}(:,:)];
    testData = [testData; testMatrix{i}(:,:)];
    testNeighbourData = [testNeighbourData; neighboursData{i}(:,:)];  
    testNeighbourDataPerClass = testNeighbourData(i,:);
    neighDataPerClass = [];
    for j = 1:5
        neighDataPerClass = [neighDataPerClass; cell2mat(testNeighbourDataPerClass(1,j))];
    end
    neighMatrix{i} = neighDataPerClass;
    neighData = [neighData;  neighMatrix{i}];
end
testNeighLabels = zeros(size(neighData,1),1);




%% Generate the endmembers
%  Having all the trainint pixels for each class we calculate the mean
%  pixel/spectral vector for each class and use these mean pixels as our
%  end members
endMembers = [];
for i = 1:(numClasses)
    classSpectrum = trainMatrix{i};
    endMembers = [endMembers; mean(classSpectrum)];
    meanSpectrum{i} = mean(classSpectrum);
end
endMembers = endMembers';

% save endMembers_mean_10_11_2015 endMembers