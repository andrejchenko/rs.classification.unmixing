%%Train the libsvm classifier including the most informative - neighbouring pixels and classify the test pixels

function [predict_label, accuracy, prob_values] = svmExtendedClassification(trainData,trainLabels, testData, testLabels,info_candidates_PerClass)
numClasses = 16;
    for i=1:numClasses
        trainData = [trainData; info_candidates_PerClass{i}];
        labels = ones(size(info_candidates_PerClass{i},1),1);
        labels = labels*i;
        trainLabels = [trainLabels; labels];
    end
    
    tic;
    % Select the optimum parameters: gamma -g and cots -c from the higest cross validation accuracy 
    [bestG,bestC] = selectParams(trainData,trainLabels);
    
    % Train the LIB_SVM with the optimum parameters
    % C-SVM, RBF kernel, cost = ..., gamma = ..., -b - probabilistics

    %cmd = '-s 0 -t 2 -c 10 -g 0.07 -b 1';
    cmd = ['-s 0 -t 2 -c ', num2str(bestC), ' -g ', num2str(bestG), ' -b 1'];
    model = libsvmtrain(trainLabels, trainData, cmd);

    save svm_model_16_10_2015 model
    % Use the SVM model to classify the data
    [predict_label, accuracy, prob_values] = libsvmpredict(testLabels, testData, model, '-b 1'); % run the SVM model on the test data
    time = toc;
    %save svmClassification_10_11_2015_5Pix_train_Rest_test_10_cv trainData  trainLabels testData testLabels time predict_label accuracy prob_values
    save svmModel  model
    end

function [bestG,bestC] = selectParams(trainData,trainLabels)
    bestcv = 0;
    log2c = -1:1:20;
    log2g = -5:1:5;

    cGridLength = length(log2c);
    gGridLength = length(log2g);
    
    for indexc = 1:cGridLength,
       clc;
       fprintf('Iteration %i of %i...',indexc,cGridLength);
        for indexg = 1:gGridLength,
            cmd = ['-v 10 -c ', num2str(2^log2c(indexc),2), ' -g ', num2str(2^log2g(indexg)), '  -b 1'];
            cv = libsvmtrain(trainLabels, trainData, cmd);
            if (cv >= bestcv),
                bestcv = cv; bestC = 2^log2c(indexc); bestG = 2^log2g(indexg);
            end
        end
    end
end

