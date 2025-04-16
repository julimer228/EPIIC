% Script to test different filtration types
[im_file, im_path] = uigetfile({'*.tif' ; '*.tiff';"*.png"}, 'Select an image');
im_org_uint16 = imread([im_path '\' im_file]);
im_org = conv_to_uint8(im_org_uint16);
imwrite(im_org, 'jpg_conv.jpg', 'jpg', 'Quality', 30);
im= imread('jpg_conv.jpg');
% use gpuArrays or not
gpu = false;

%% EPIIC

opts.Sigma = 1.4;
opts.Size = 3;

im_1 = process_image(im, opts, "EPA-HE",gpu );
a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_1), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);

%% EPIIC Sobel

opts1.Sigma = 1.4;
opts1.Size = 3;

im_1 = process_image(im, opts1, "EPA-HE",gpu );
a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_1), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);

%% 11. avg_filering 
opts11.Size = 3;

im_11 = process_image(im, opts11, "avg_filtering",gpu);
figure;
a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_11), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);

%% 12. gaussian_filtering 

opts12.Size = 3;
opts12.Sigma = 0.9;

im_12 = process_image(im, opts12, "gaussian_filtering",gpu);
a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_12), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);

%% 13. guided_filtering - does not support gpuArrays
opts13.DoS = 0.001;
opts13.NeighSize = 3;

im_13 = process_image(im, opts13, "guided_filtering",false);
a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_13), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);

%% 14. imbilateral_filtering - does not support gpuArrays
opts14.DoS =1.1;
opts14.Sigma = 1.4;
im_14 = process_image(im, opts14, "imbilateral_filtering",false);
a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_14), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);



%% 15. Anisotropic diffusion filtering (imdiffusse_filtering) - does not support gpuArrays
opts15.ConductionMethod = "exponential";
opts15.Connectivity = "minimal";
im_15 = process_image(im, opts15, "imdiffuse_filtering",false);
a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_15), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);

%% 16. median_filtering 

opts16.Size = 3;

im_16 = process_image(im, opts16, "median_filtering",gpu);

a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_16), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);
%% 17. non_local_means_filtering - does not support gpuArrays

opts17.DoS = 1.7;

im_17 = process_image(im, opts17, "non_local_means_filtering",false);
imshowpair(im, im_17, "montage");

a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_17), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);

%% 19. wiener_filtering

opts19.Size = 3;

im_19 = process_image(im, opts19, "wiener_filtering",gpu);
a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_19), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);

%% 20 a) MMWF - gpuArrays - time consuming

opts20a.Size = 3;
opts20a.Filter = "MMWF";

im_20a = process_image(im, opts20a, "MMWF_2D_filtering",false);

a = subplot(1,3,1); imshow(im_org), title("Original image");
b = subplot(1,3,2); imshow(im), title("JPEG Q=30");
c = subplot(1,3,3); imshow(im_20a), title("Processed image");
set(a, 'Position', [0 0.3 0.4 0.3]);
set(b, 'Position', [0.3 0.3 0.4 0.3]);
set(c,'Position',[0.6 0.3 0.4 0.3]);
