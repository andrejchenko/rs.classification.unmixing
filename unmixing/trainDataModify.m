% 1. Remove classes 1, 7, 9
%    modify: trainMatrix, trainData and trainLabels,
%            testMatrix, testData, testLabels
% 2. Add pixels to class 4 and 13
%    - modify: trainMatrix, trainData and trainLabels
% 3. Remove pixels from class 4 and 13
%    - modify: testMatrix, testData, testLabels

function [trainMatrixRe,testMatrixRe,trainLabelsRe,testLabelsRe,trainDataRe,testDataRe,means] = trainDataModify()

    load('svmClassification_16_10_2015_40_train_60_test_10_cv');
    load('trainingAndTestMatrices');
    numClasses = 15;

    trainDataRe = [];
    testDataRe = [];
    % 1.
    for i = 1:numClasses
        if ((i == 1) || (i == 7) || (i == 9))
            ;  % do nothing 
            % do not add pixels from class i from trainData, testData and
            % remove lables for those pixels from trainLabels, testLabels
            % b = a(a~=3);
            % x(x==1) = [];
            trainLabels(trainLabels == i) = [];
            testLabels(testLabels == i) = [];
        else
            trainMatrixRe{i} = trainMatrix{i};
            testMatrixRe{i} = testMatrix{i};
            trainDataRe = [trainDataRe; trainMatrixRe{i}(:,:)];
            testDataRe = [testDataRe; testMatrixRe{i}(:,:)];
            % for the trainLabels and testLabels we dont do anything here
        end
    end
    trainLabelsRe = trainLabels;
    testLabelsRe = testLabels;
    
    % 2.
    % Modify trainMatrixRe,testMatrixRe, trainLabelsRe and testLabelsRe for class 4
    temp = trainMatrixRe{4};
    trainMatrixRe{4} = [];
    trainMatrixRe{4} = [temp; testMatrixRe{4}(1:100,:)];
    testMatrixRe{4}(1:100,:) = [];
    idx = find(trainLabelsRe == 4,1,'last');
    trainLabelsRePart = trainLabelsRe(1:idx);
    testLabelsRe(idx+1:idx+100) = [];
    len = size(trainLabelsRe,1);
    labels4 = 4*ones(100,1); 
    trainLabelsRe =  [trainLabelsRePart; labels4; trainLabelsRe(idx+1:len)];
    
    % Modify trainMatrixRe,testMatrixRe, trainLabelsRe and testLabelsRe for class 13
    temp = trainMatrixRe{13};
    trainMatrixRe{13} = [];
    trainMatrixRe{13} = [temp; testMatrixRe{13}(1:100,:)];
    testMatrixRe{13}(1:100,:) = [];
    idx = find(trainLabelsRe == 13,1,'last');
    trainLabelsRePart = trainLabelsRe(1:idx);
    testLabelsRe(idx+1:idx+100) = [];
    len = size(trainLabelsRe,1);
    labels13 = 13*ones(100,1);  
    trainLabelsRe =  [trainLabelsRePart; labels13; trainLabelsRe(idx+1:len)];

    % Modify trainMatrixRe,testMatrixRe, trainLabelsRe and testLabelsRe for class 15
    temp = trainMatrixRe{15};
    trainMatrixRe{15} = [];
    trainMatrixRe{15} = [temp; testMatrixRe{15}(1:100,:)];
    testMatrixRe{15}(1:100,:) = [];
    idx = find(trainLabelsRe == 15,1,'last');
    trainLabelsRePart = trainLabelsRe(1:idx);
    testLabelsRe(idx+1:idx+100) = [];
    len = size(trainLabelsRe,1);
    labels15 =15*ones(100,1);  
    trainLabelsRe =  [trainLabelsRePart; labels15; trainLabelsRe(idx+1:len)];
    
    trainDataRe = [];
    testDataRe = [];
    for i = 1:numClasses
         trainDataRe = [trainDataRe; trainMatrixRe{i}(:,:)];
         testDataRe = [testDataRe; testMatrixRe{i}(:,:)];
    end
    
    means = [];
    for i = 1:(numClasses)
        classSpectrum = trainMatrixRe{i};
        if((i==1)||(i==7) ||(i==9))
            meanVec = zeros(166,1)';
        else
            meanVec = mean(classSpectrum);
        end
        means = [means; meanVec];
    end
    means = means';    
end