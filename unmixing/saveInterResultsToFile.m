function saveInterResultsToFile(a,maxAcc,maxW)
    fileID = fopen('Combination_SVM_Sunsal_sumAbundancePerClass.txt','a');
    %fprintf(fileID,'Iteration: %d, Accuracy of pixelwise combination of SVM + BT + Sunsal Unmixing (on normalized data): %4.3f, with weight: %4.3f\n',a,maxAcc,maxW);
    fprintf(fileID,'Iteration: %d, Accuracy of combination of SVM + BT + Sunsal Unmixing (on normalized data): %4.3f: %4.3f\n',a,maxAcc);
    fclose(fileID);
end