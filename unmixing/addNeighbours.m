% x_coor + 1;   y_coor - 1   up right
% x_coor + 1;   y_coor + 1   low right
% x_coor-1;     y_coor + 1   low left
% x_coor-1;     y_coor - 1   up left
% select only 4 neighbouring pixels out of 8

function  [neighbours,neighboursData] = addNeighbours(z,x_coor,y_coor,neighbours,i,j,neighboursData,indian_pines)

if(z == 1)
    neighbours{i}{j} =[neighbours{i}{j}; x_coor + 1 y_coor - 1];
    neigh_Pix = indian_pines(x_coor + 1,y_coor - 1,:);
    neigh_Pix = reshape(neigh_Pix, 1,size(neigh_Pix,3));
    neighboursData{i}{j} =[neighboursData{i}{j}; neigh_Pix];
    %neighbours{i}{j}(1,1) = x_coor + 1;
    %neighbours{i}{j}(1,2) = y_coor - 1;
elseif(z==3)
    neighbours{i}{j} =[ neighbours{i}{j}; x_coor + 1 y_coor + 1];
    neigh_Pix = indian_pines(x_coor + 1,y_coor + 1,:);
    neigh_Pix = reshape(neigh_Pix, 1,size(neigh_Pix,3));
    neighboursData{i}{j} =[neighboursData{i}{j}; neigh_Pix];
    %neighbours{i}{j}(2,1) = x_coor + 1;
    %neighbours{i}{j}(2,2) = y_coor + 1;
elseif(z == 5)
    neighbours{i}{j} =[ neighbours{i}{j}; x_coor - 1 y_coor + 1];
    neigh_Pix = indian_pines(x_coor - 1,y_coor + 1,:);
    neigh_Pix = reshape(neigh_Pix, 1,size(neigh_Pix,3));
    neighboursData{i}{j} =[neighboursData{i}{j}; neigh_Pix];
    %neighbours{i}{j}(3,1) = x_coor - 1;
    %neighbours{i}{j}(3,2) = y_coor + 1;
elseif(z == 7)
    neighbours{i}{j} =[ neighbours{i}{j}; x_coor - 1 y_coor - 1];
    neigh_Pix = indian_pines(x_coor - 1,y_coor - 1,:);
    neigh_Pix = reshape(neigh_Pix, 1,size(neigh_Pix,3));
    neighboursData{i}{j} =[neighboursData{i}{j}; neigh_Pix];
    %neighbours{i}{j}(4,1) = x_coor - 1;
    %neighbours{i}{j}(4,2) = y_coor - 1;
end