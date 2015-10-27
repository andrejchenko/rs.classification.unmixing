%d1 = sqrt((M-p)'*V*(M-p));
%d2 = sqrt((M-p)'*inv(V)*(M-p));
function mahalDist()
    load('svmClassification_16_10_2015_40_train_60_test_10_cv');
    load('trainingAndTestMatrices');
    
    for i = 1:15
        m = mean(trainMatrix{i})';
        V = cov(trainMatrix{i});
        dist = [];
        for j = 1: size(trainMatrix{i},1)
            x = trainMatrix{i}(j,:)';
            d = sqrt((x-m)'*inv(V)*(x-m));
            dist = [dist; d];
        end
        %D2 = mahal(trainMatrix{i},trainMatrix{i}); %fails: number of 
        % rows < number of columns, num of pixels < number of dimensions
        stop = 1;
    end
end