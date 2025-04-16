%% Script to process dataset - files will be compressed with a chosen quality
% factor and then artifacts will be removed from the image with the chosen 
% method

dataset.filepath = "C:\Users\Julia\Downloads\BreCaHAD\BreCaHAD\";
dataset.result = "E:\Results\BreCaHAD\";
dataset.filetype = "tif";
dataset.Q = 10:10:90;

opts.Sigma = 0.4:0.3:3.0;
opts.Size = [3,5,7];
opts.T_mult = [1.25, 1.5, 1.75, 2];
opts.avg_size = [3, 5, 7];
opts.save = 0;
opts.he=1;

opts.path = "E:\EPA_ID_HE_19_01_RGB_BSDS500\im";


method = "EPIIC_Sobel";
if(method=="EPA_ID_fitted")
    tab = process_dataset_EPA_ID_fitted(dataset, method, opts);
else
    tab=process_dataset(dataset, method, opts);
end