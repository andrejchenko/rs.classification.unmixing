function saveAverageResultToFile(avgOfmaxAcc)
fileID = fopen('Combination_SVM_Sunsal_sumAbundancePerClass.txt','a');
fprintf(fileID,'Average accuracy: %4.3f\n',avgOfmaxAcc);
fclose(fileID);
end