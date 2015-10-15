function [indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image()

    indian_pines_raw = multibandread('\data\datasets\AVIRIS_Indian_Pines\raw\aviris', [145 145 220], 'uint16', 0, 'bsq', 'ieee-le');
    %samples = 145
    %lines   = 145
    %bands   = 220

    Xcoor = 1:145;
    Ycoor = 1:145;
    bands = setdiff(1:220,[1:4 103:113 148:166]);

    indian_pines_scaled = indian_pines_raw/10000; % to get the reflectance values

    bands = setdiff(1:200,[1:4 103:113 148:166]); % remove certain noisy bands
    numBands = size(bands,2);
    indian_pines = indian_pines_scaled(:,:,bands);
    %indian_pines_gtStruct = load('E:\Projects\Matlab\data\datasets\AVIRIS_Indian_Pines\Indian_pines_gt.mat');
    indian_pines_gtStruct = load('Indian_pines_gt.mat');
    indian_pines_gt = indian_pines_gtStruct.indian_pines_gt;
end