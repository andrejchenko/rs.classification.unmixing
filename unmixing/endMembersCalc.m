function endMembers = endMembersCalc(trainMatrix)
endMembers = [];
numClasses = 16;
for i = 1:(numClasses)
    classSpectrum = trainMatrix{i};
    endMembers = [endMembers; mean(classSpectrum)];
    meanSpectrum{i} = mean(classSpectrum);
end
endMembers = endMembers';
end
