%% Calculate the distances between the class means -> class mean spectra -> endmembers
function dist = meanDistances(endMembers)
dist = [];
    for i = 1: size(endMembers,2)
        for j = 1:size(endMembers,2)
            if(i ~= j)
                d = norm(endMembers(:,i) - endMembers(:,j));
                dist = [dist; i j d];
            end
        end
    end
end

