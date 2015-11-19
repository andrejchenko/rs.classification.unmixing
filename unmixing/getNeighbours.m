% 1.  for each training pixel find his 8 neighbours
% 2.  check wether all these 8 pixels are within  the boundaries of the
%     indian pines image, if yes
% 3.  check if any of this 8 neighbours belong to the test pixels
%     testPixindClass{1},testPixindClass{2},testPixindClass{3},....testPixindClass{15}
%     irrespective of the class they belong to, if yes
% 4.  select only 4 neighbours
% 5.  remove these 4 pixels from the testPixIndClass
% 6.  add them in a temporary container neighbours{i}{j} == neighbours{class}{center_pixel}
% 7.  obtain the posterior probabilites/hard labels for these neighbouring pixels by using them as
%     test pixels  in the SVM classifier -> classify then with the SVM
% 8.  if a neighbouring pixel has the same hard label as our center
%     pixel, add it to the candidate set per pixel/iteration: candidatesPerPixel{class}{center_pixel}
% 9.  for all candidates at the current itteration find the posterior probabilities for
%     all classes.
% 10. find the difference between the 2 highest posterior probabilities
%     for each pixel in the candidate set
% 11. select the pixel with the smallest difference in the highest
%     posterior probabilities as a most informative pixel - pixel
%     containing the most uncertainity and add it to the unlabled set
%     D_u. Later on when all these most infomrative pixels are chosen
%     and added to the D_u, the labeled set D_l is extended:
%     D_l = D_l + D_u and this extended set D_l is used for training the SVM classifier

function [neighbours,neighboursData,testPixIndClass] = getNeighbours(trainPixIndClass,testPixIndClass,numClasses,indian_pines,classTrainIndex)
size1 = size(indian_pines,1);
size2 = size(indian_pines,2);

for i = 1:(numClasses)
        for j = 1: size(trainPixIndClass{i},1)
            %neighbours{i}{j} = zeros(4,2); % 4 neighbours
            neighbours{i}{j} = []; % 4 neighbours
            neighboursData{i}{j} = []; 
            centerPix_idx = classTrainIndex{i}(j);
            x_coor = trainPixIndClass{i}(j,1);
            y_coor = trainPixIndClass{i}(j,2);
            inside = checkBoundary(x_coor,y_coor,size1, size2); % check if we are inside the boundaries of our indian pines image
            for z = 1:size(inside,2)
                if(inside(z) == 1)
                    % Check wether the neighbouring pixel is part of the
                    % Set of test Pixels
                    testPixIndClass = checkTestPixIndClass(x_coor,y_coor,z,testPixIndClass,numClasses);% if yes remove it from the testing pixels
                    % Add it to the neighbouring set of the current
                    % (center) pixel
                    [neighbours,neighboursData] = addNeighbours(z,x_coor,y_coor,neighbours,i,j,neighboursData,indian_pines);
                else
                    str = 'Some neighbouring pixels are outside the boundaries of the image: image pines'
                    str
                end
            end
        end
        % In the next section we use these neighbouring pixels for each class as testing pixels and classify them in order to be able to
        % obtain a label for them and posterior probabilities 
end
end