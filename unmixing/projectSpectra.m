%% Project test pixels/spectra into the endmember space y = E'*x, dimensons: pxN = pxd * dxN
%  Endmembers are the mean class pixels/spectra computed from the training
%  pixels/spectra
%  Project endmembers to endmembers space as well: E = E'*E;
%  Do the unmixing on the projected test pixels/spectra y. We get the
%  abundance values for the projected test pixels.
function projectSpectra()
    load('endMembers_mean_15_10_2015');
    load('svmClassification_15_10_2015_40_train_60_test_10_cv');
    E = endMembers;
    projTestData = E' * testData';
    E = E'*E;
    alphas = FCLSU_fast(projTestData',E)'; 
    alphasT = alphas';
    alphaLabels = getLabels(alphasT);
    EVAL_APHA = calcAccuracy(testLabels,alphaLabels);
    % abundance accuracy of 30%
end

%% Hard labeling using the maximal abundance value
function labels = getLabels(alphasT)
    maxArray = []; maxIndexArray = [];
    for i = 1:size(alphasT,1)
        maxEl = 0; maxIndex = 0;
        for j = 1:size(alphasT,2)
            if(alphasT(i,j) > maxEl)
                maxEl = alphasT(i,j);
                maxIndex = j;
            end
        end
        maxArray = [maxArray; maxEl];
        maxIndexArray = [maxIndexArray; maxIndex];
    end
    labels = maxIndexArray;
end