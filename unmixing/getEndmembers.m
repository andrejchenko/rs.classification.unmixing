%% Generate the endmembers
%  Having all the trainint pixels for each class we calculate the mean
%  pixel/spectral vector for each class and use these mean pixels as our
%  end members
function endMembers = getEndmembers(trainMatrix, numClasses)
endMembers = [];
for i = 1:(numClasses)
    classSpectrum = trainMatrix{i};
    endMembers = [endMembers; mean(classSpectrum)];
    meanSpectrum{i} = mean(classSpectrum);
end
endMembers = endMembers';
% save endMembers_mean_10_11_2015 endMembers
end