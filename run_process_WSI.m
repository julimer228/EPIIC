% WSI with EPA_ID processing example

opts.Sigma =0.7;
opts.Size = 3;
blocksize = [1024 1024];
parallel = true;
opts.Method = "EPIIC_Sobel";
opts.He=1;
res_path="new.svs";
filepath = "TCGA.svs";
process_WSI(filepath, blocksize, parallel, res_path, opts);

%% Display blocked image
bim = blockedImage(res_path);
info = imfinfo(res_path);
bigimageshow(bim)

%% Display the part of the image
processed = imread(res_path,'Index',1,'PixelRegion', {[5000 11000],[800 800]});
org = imread(filepath,'Index',1,'PixelRegion', {[5000 11000],[800 800]});
imshowpair(processed, org, 'montage');