function alphas = sunsalUnmixing(trainNeighData,trainNeighLabels,testData,testLabels, lambda)
    %% Sunsal unmixing
    E = trainNeighData'; % use only the initial train data - 5 pixels and their neighbours, not using the BT pixels
    % lambda = 0.9;
    alphas = sunsal(E,testData','Positivity','yes','addone','no','lambda',lambda);

    [Y,I] = max(alphas);
    label = trainNeighLabels(I);
    EVAL_APHA = calcAccuracy(testLabels,label);
    str = ['Sunsal Unmixing accuracy: ', num2str(EVAL_APHA(1)*100)];
    str
end