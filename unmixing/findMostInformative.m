function info_candidates_PerClass = findMostInformative(candidates_Pix,candidates_LabPix,candidates_postProb)
numClasses = 16;

for i = 1:numClasses
    info_candidates = [];
    for z = 1: 5 % 5 training pixels per class
        differences = [];
        for j = 1:size(candidates_Pix{i}{z},1)
            if(size(candidates_Pix{i}{z},1) == 1)
                % if there is only one neighbouring pixel add it directly
                % as a most informative neighbouring pixel
                info_candidates = [info_candidates; candidates_Pix{i}{z}(j,:)];
            elseif(size(candidates_Pix{i}{z}) > 1) % otherwise find the most informative neighbouring pixel for our center pixel
                candidates_postProb{i}{z}(j,:) % row of probabilities per neighbouring pixel
                A = candidates_postProb{i}{z}(j,:);
                B = sort(A);
                M = 2;
                N = size(candidates_postProb{i}{z}(j,:),2);
                smallest = B(N-M+1); 
                
                indices = find(A >= smallest);
                index1 = indices(1);
                index2 = indices(2);
                prob1 = candidates_postProb{i}{z}(j,index1);
                prob2 = candidates_postProb{i}{z}(j,index2);
                diff = abs(prob1-prob2);
                differences = [differences; diff];
            end
        end
        % find the smallest difference and then the index of the
        % neighbouring pixel producing this smallest difference
        [minVal,minIdx] = min(differences);
        candidates_Pix{i}{z}(minIdx,:);
        info_candidates = [info_candidates; candidates_Pix{i}{z}(minIdx,:)];
    end
    info_candidates_PerClass{i} = info_candidates;
end
stop = 1;
end