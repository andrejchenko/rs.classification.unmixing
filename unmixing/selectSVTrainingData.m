% 1. Get the Support Vectors from the training model
% 2. Use the set of Support Vectors from each class, calculate their mean
% and use those means as end members
% 3. Input these enmembers into the FCLSU unmixing method to get the
% abundance values
function endMembers = selectSVTrainingData(model,trainData,trainLabels)
    trainSVmatrix = [];
    trainSVLabels = [];
  
    for i=1:size(model.sv_indices,1)
        sv_label = trainLabels(model.sv_indices(i));
        trainSVLabels = [trainSVLabels; sv_label];
        pix = trainData(model.sv_indices(i),:);
        trainSVmatrix = [trainSVmatrix; pix]; 
    end
    
    trainLabelsNew = [];
    numClasses = model.nr_class;
    for j = 1: numClasses
        trainMatrix{j} = [];
        for i = 1: size(model.sv_indices,1)
            if(trainSVLabels(i) == j)
                trainMatrix{j} = [trainMatrix{j}; trainSVmatrix(i,:)];
                trainLabelsNew = [trainLabelsNew; trainSVLabels(i)];  
            end
        end
    end

    %% Generate the endmembers
    %  Having all the trainint pixels for each class we calculate the mean
    %  pixel/spectral vector for each class and use these mean pixels as our
    %  end members
    endMembers = [];
    for i = 1:(numClasses)
        classSpectrum = trainMatrix{i};
        endMembers = [endMembers; mean(classSpectrum)];
        meanSpectrum{i} = mean(classSpectrum);
    end
    endMembers = endMembers';
end