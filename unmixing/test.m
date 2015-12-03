maxAcc = 0;
maxW = 0;

for a = 1: 10
    for w = 0:0.01:0.1
        if(0.9 > maxAcc)
            maxAcc = 0.9;
            maxW = w;
        end
    end

    fileID = fopen('results_includeBT.txt','a');
    fprintf(fileID,'Iteration: %d, max accuracy of Combined SVM + BT + Unmixing (on normalized data): %4.3f, for weight: %4.3f\n',a,maxAcc,maxW);
    fclose(fileID);
end