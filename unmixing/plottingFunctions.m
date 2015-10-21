
%% Plotting the original spectrums - pixels and the reconstructed ones from the unmixing method (E*alpha)
%  Compare the values from different bands
function plottingFunctions()
    [indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();
    procent = 0.4;
    [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix, classTrainIndex,classTestIndex,classIndex] = selectTrainingPixels(indian_pines,indian_pines_gt,procent,numBands);
    E = endMembers;
    reIndianPines = reshape(indian_pines,145*145,166); % N x d = 21025 x 166 indian pines reshaped
    alphas = FCLSU_fast(reIndianPines,E)'; 
    alphasT = alphas';
    alphaReShaped = reshape(alphasT,145,145,15);
    % We have close class means between class 1 and class 8, we select any
    % pixel from class 1
    class = 11;
    index = classTrainIndex{class}(90);
    
    xInd = classIndex{class}(index,1); 
    yInd = classIndex{class}(index,2);
    
    alphaX = reshape(alphaReShaped(xInd,yInd,:),1,15)';
    
    %recPix = E * alphaReShaped(xInd,yInd,:);
    recPix = E * alphaX;
    orgPix = reshape(indian_pines(xInd,yInd,:),1,166)';
    
    xAxis = 1:1:166;
    figure;
    plot(xAxis,recPix,'r');
    figure;
    plot(xAxis,orgPix,'g');
    
   
    stop = 1;
    %xRec = E*alphas();
end

function [trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix, classTrainIndex,classTestIndex,classIndex] = selectTrainingPixels(indian_pines,indian_pines_gt,procent,numBands)

%% Find the indices of each class value from the ground truth indian pines
%  Store the indices for all classes in a classIndex variable
numClasses = 15;
for i = 1:(numClasses)
    classMatrix = indian_pines_gt(:,:) == i;  
    class{i} = classMatrix;
    [rowClass,colClass] = find(class{i} == 1);  
    classIndex{i} = [rowClass colClass];
end

for i = 1:(numClasses)
    len = size(classIndex{i},1); % 46 pixels in total for the first class 
    
    trainPixelsNum = floor(procent * len);
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
save trainingAndTestMatrices trainMatrix testMatrix
trainData = [];
testData = [];
for i = 1:(numClasses)
    trainData = [trainData; trainMatrix{i}(:,:)];
    testData = [testData; testMatrix{i}(:,:)];
end

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
end