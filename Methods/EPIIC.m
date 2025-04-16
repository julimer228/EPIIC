function im_res = EPIIC(im, opts)

% EPA_ID_HE_Sobel EPA_ID algorithm with gaussian filtering
% im - jpg image (uint8)
% opts - structure with following parameters
% - Size - size of the filter
% - Sigma - std of the gaussian filter
% - path - path to save steps
% - name - image's name to save steps
% - save - true/false - save steps or not
% returns im_res - filtred image
im=im2double(im);

% preallocate memory
[n, m, d] = size(im);
im_res=zeros(n,m,d,'double');

if opts.he==1
    [H,~,~]=HEdeconvolve(im);
else
     H = im2gray(im);
end

if opts.save
    imwrite(H, sprintf("%s/%s_H.png",opts.path, opts.name));
    imwrite(im, sprintf("%s/%s_compressed.png",opts.path, opts.name));
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

if opts.save
    imwrite(H_adj_gmag_grayscale, sprintf("%s/%s_gmag.png",opts.path, opts.name));
    imwrite(M_bin, sprintf("%s/%s_M_bin.png",opts.path, opts.name));
    imwrite(M, sprintf("%s/%s_M.png",opts.path, opts.name));
    imwrite(H_adj, sprintf("%s/%s_H_adj.png",opts.path, opts.name));
end

% make a filter based on the chosen parameters
filter_mask=gaussian_mask(opts.Sigma, opts.Size);
map_edges = imcomplement(M);
W = imfilter(map_edges, filter_mask, 'symmetric', 'conv');

if opts.save
    imwrite(W, sprintf("%s/%s_W.png", ...
        opts.path, opts.name));
    imwrite(map_edges, sprintf("%s/%s_map_edges.png", ...
        opts.path, opts.name));
end

for i=1:d
    % filter whole image layer
    im_res(:,:,i) = imfilter(im(:,:,i) .* map_edges, ...
        filter_mask, 'symmetric', 'conv') ./ W;
end

im_res = im2uint8(im_res);
if opts.save
    imwrite(im_res, sprintf("%s/%s_epiic.png", ...
        opts.path, opts.name));
end
