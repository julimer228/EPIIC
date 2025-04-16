function im_res = EPIIC_Sobel_WSI(im_org,opts)
% EPIIC Sobel WSI function to remove compression artifacts from a WSI image
% im_org - compressed image block to process
% opts - structure with following parameters:
% - Params - calculated threshold values for Otsu algorithm
% - Size - size of the filter
% - Sigma - standard diviation of the gaussian filter
% - He - use stain decomposition (1) or not (0)
% returns im_res - processed image block
% * This function is created for block processing

im=im2double(im_org);

% preallocate memory
[n, m, d] = size(im);
im_res=zeros(n,m,d,'double');
all_edges=zeros(n,m,d,'double');

if opts.He==1
    [H,~,~]=HEdeconvolve(im);
else
     H = im2gray(im);
end

% image closing
se = strel('disk',3);
H_closed = imclose(H,se);

% adjust contrast (remove background)
H_adj=imadjust(H_closed,[0 0.75],[0 1]);
% remove noise from background
avg = fspecial("average",[5 5]);
H_filtred = imfilter(H_adj,avg,"symmetric");
 
% find edges
[~,T] = edge(H_filtred,"Sobel");
M = edge(H_filtred,"Sobel",T*0.5);

for i=1:d
    layer = im(:,:,i);
    [gmag, ~] = imgradient(layer, 'central');
    gmag_grayscale = mat2gray(gmag);
    gmag_grayscale(M == 0) = 0;
    gmag_grayscale(M == 1) = gmag_grayscale(M > T) - T;
    all_edges(:,:,i) = gmag_grayscale ./(1-T);
end

% make a filter based on the chosen parameters
filter_mask=gaussian_mask(opts.Sigma, opts.Size);

for i=1:d

    map_edges = imcomplement(all_edges(:,:,i));

    % make a weights map for each layer
    W = imfilter(map_edges, filter_mask, 'symmetric', 'conv');

    % filter whole image layer
    im_res(:,:,i) = imfilter(im(:,:,i) .* map_edges, ...
        filter_mask, 'symmetric', 'conv') ./ W;

end

im_res = im2uint8(im_res);

end
