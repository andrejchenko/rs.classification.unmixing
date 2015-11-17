function [candidates,candidateLabels,post_prob_values_refPerClass,candidates_Pix,candidates_LabPix,candidates_postProb] = createCandidates(trainLabels,neighData,predict_label_neigh,neighbours,post_prob_values)
numClasses = 15;

counter = 1;
for a = 1: numClasses
    for z = 1: 5
        candidatesPerPix = [];  candidatesLabPerPix = []; post_prob_values_ref = [];
        mat = cell2mat(neighbours{a}(z));
        numNeighPix = size(mat,1);
        for j = 1: numNeighPix
            if (a == predict_label_neigh(counter))
                candidatesPerPix =[candidatesPerPix; neighData(counter,:)];
                candidatesLabPerPix =[candidatesLabPerPix; predict_label_neigh(counter)];
                post_prob_values_ref = [post_prob_values_ref; post_prob_values(counter,:)];
            end
            counter = counter + 1;
        end
        candidates_Pix{a}{z} = candidatesPerPix;
        candidates_LabPix{a}{z} = candidatesLabPerPix;
        candidates_postProb{a}{z} = post_prob_values_ref;
    end
    candidates{a} = candidatesPerPix;
    candidateLabels{a} = candidatesLabPerPix;
    post_prob_values_refPerClass{a} = post_prob_values_ref;
end
end