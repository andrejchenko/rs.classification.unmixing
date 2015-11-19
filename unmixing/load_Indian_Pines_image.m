function [indian_pines_gt,indian_pines,numBands] = load_Indian_Pines_image()

    indian_pines_raw = multibandread('\data\datasets\AVIRIS_Indian_Pines\raw\aviris', [145 145 220], 'uint16', 0, 'bsq', 'ieee-le');
    %samples = 145
    %lines   = 145
    %bands   = 220

    Xcoor = 1:145;
    Ycoor = 1:145;
    % On the calibrated data from Purdue University on this page: https://purr.purdue.edu/publications/1947/supportingdocs
    % they are working with the radiance values, not reflecance values...so
    % instead of: indian_pines_scaled = indian_pines_raw/10000; % to get the reflectance values
    indian_pines_scaled = indian_pines_raw/10000; % to get the reflectance values
    % I can try: RV = (SDV-1000) / 500.
    % indian_pines_scaled = (indian_pines_raw - 1000)/500;
    % bands = setdiff(1:220,[1:4 103:113 148:166]); from Rob
    % On the calibrated data from Purdue University on this page: https://purr.purdue.edu/publications/1947/supportingdocs
    % they are not using: 1,33,97 and 161 band.
    % I have to remove the 31st and 97th band additionally
    bands = setdiff(1:200,[1:4 33:33 97:97 103:113 148:166]); % remove certain noisy bands
    numBands = size(bands,2);
    indian_pines = indian_pines_scaled(:,:,bands);
    %indian_pines_gtStruct = load('E:\Projects\Matlab\data\datasets\AVIRIS_Indian_Pines\Indian_pines_gt.mat');
    indian_pines_gtStruct = load('Indian_pines_gt.mat');
    indian_pines_gt = indian_pines_gtStruct.indian_pines_gt;
end