function im_res = EPIIC_Sobel(im, opts)
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

%preallocate memory
[n, m, d] = size(im);
im_res=zeros(n,m,d,'double');
all_edges=zeros(n,m,d,'double');

if opts.he==1
    [H,~,~]=HEdeconvolve(im);
else
     H = im2gray(im);
end

if opts.save
    imwrite(H, sprintf("%s/%s_H.png",opts.path, opts.name));
    imwrite(im, sprintf("%s/%s_compressed.png",opts.path, opts.name));
end

% image closing
se = strel('disk',3);
H_closed = imclose(H,se);

% adjust contrast (remove background)
H_adj=imadjust(H_closed,[0 0.75],[0 1]);
% remove noise from background
avg = fspecial("average",[opts.avg_size opts.avg_size]);
H_filtred = imfilter(H_adj,avg,"symmetric");
 
%find edges
 [~,T] = edge(H_filtred,"Sobel");
M = edge(H_filtred,"Sobel",T*opts.T_mult);

[gmag, ~] = imgradient(H_filtred, "Sobel");
gmag = mat2gray(gmag);



if opts.save
    imwrite(gmag, sprintf("%s/%s_gmag.png",opts.path, opts.name));
    imwrite(M, sprintf("%s/%s_M.png",opts.path, opts.name));
    imwrite(H_adj, sprintf("%s/%s_H_adj.png",opts.path, opts.name));
    imwrite(H_filtred, sprintf("%s/%s_H_filtred.png",opts.path, opts.name));
end

for i=1:d
    layer = im(:,:,i);
    [gmag, ~] = imgradient(layer, 'central');
    gmag_grayscale = mat2gray(gmag);
    gmag_grayscale(M == 0) = 0;
    gmag_grayscale(M == 1) = gmag_grayscale(M > T) - T;
    all_edges(:,:,i) = gmag_grayscale ./(1-T);


    if opts.save
        imwrite(all_edges(:,:,i), sprintf("%s/%s_all_edges%d.png", ...
            opts.path, opts.name, i));
    end
end

if opts.save
    imwrite(all_edges, sprintf("%s/%s_all_edges.png", ...
        opts.path, opts.name));
end

% make a filter based on the chosen parameters
filter_mask=gaussian_mask(opts.Sigma, opts.Size);

for i=1:d

    map_edges = imcomplement(all_edges(:,:,i));
    
    if opts.save
        imwrite(map_edges, sprintf("%s/%s_map_edges%d.png", ...
            opts.path, opts.name, i));
    end

    % make a weights map for each layer
    W = imfilter(map_edges, filter_mask, 'symmetric', 'conv');

    if opts.save
        imwrite(W, sprintf("%s/%s_W%d.png", ...
            opts.path, opts.name, i));
    end

    % filter whole image layer
    im_res(:,:,i) = imfilter(im(:,:,i) .* map_edges, ...
        filter_mask, 'symmetric', 'conv') ./ W;

end

im_res = im2uint8(im_res);

    if opts.save
        imwrite(im_res, sprintf("%s/%s_sobel.png", ...
            opts.path, opts.name));
    end
end