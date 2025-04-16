function im_res = EPIIC_WSI(im_org, opts)
% EPIIC WSI function to remove compression artifacts from a WSI image
% im_org - compressed image block to process
% opts - structure with following parameters:
% - Size - size of the filter
% - Sigma - standard diviation of the gaussian filter
% - He - use stain decomposition or not
% returns im_res - processed image block
% * This function is created for block processing

im=im2double(im_org);

% preallocate memory
[n, m, d] = size(im);
im_res=zeros(n,m,d,'double');

if opts.He==1
    [H,~,~]=HEdeconvolve(im);
else
     H = im2gray(im);
end

[T_adj, ~]=graythresh(H);
% adjust contrast (remove background)
H_adj=imadjust(H,[0 T_adj],[0 1]);

% % remove noise from background
avg = fspecial("average",[5 5]);
H_adj = imfilter(H_adj,avg,"symmetric");
% find edges
[H_adj_gmag, ~] = imgradient(H_adj, "central");
H_adj_gmag_grayscale = mat2gray(H_adj_gmag);

H_adj_gmag_grayscale = imfilter(H_adj_gmag_grayscale,avg);
[T, ~]=graythresh(H_adj_gmag_grayscale); % Otsu
T=1.25*T;
M_bin = imbinarize(H_adj_gmag_grayscale,T);
M_bin = imopen(M_bin, strel("square",2));

M = immultiply(M_bin, H_adj_gmag_grayscale);
M(M>T)=(M(M>T)-T)./(1-T);

% make a filter based on the chosen parameters
filter_mask=gaussian_mask(opts.Sigma, opts.Size);
map_edges = imcomplement(M);
W = imfilter(map_edges, filter_mask, 'symmetric', 'conv');


for i=1:d
    % filter whole image layer
    im_res(:,:,i) = imfilter(im(:,:,i) .* map_edges, ...
        filter_mask, 'symmetric', 'conv') ./ W;
end

im_res = im2uint8(im_res);

