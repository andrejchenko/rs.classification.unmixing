function mesma_test()
[indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image();

[trainData,trainLabels, testData, testLabels,endMembers,trainMatrix,testMatrix,neighbours,neighData,neighMatrix,testNeighLabels] = select5PixPerClass_IncludeNeighbours(indian_pines,indian_pines_gt,numBands);

numClasses = 16;
for i = 1:numClasses
    trainMatrix{i} = trainMatrix{i}';
end
testData = testData';
[idx, A, rec, minerr]=MESMA_brute_small (testData,trainMatrix);

stop = 1;

end


