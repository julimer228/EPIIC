function im_res = guided_filtering(im,opts)
%GUIDED_FILTERING performs guided filtering
% INFO: does not support gpuArrays
% im - jpg image (uint8)
% opts - structure with following parameters
% - DoS - degrees of smoothing;
% - NeighSize - neighborhood size;
% returns im_res - filtred image
im = im2double(im);
[n, m, d] = size(im);

im_res=zeros(n,m,d,'double');
for i=1:d
    im_res(:,:,i) = imguidedfilter(im(:,:,i), "DegreeOfSmoothing", opts.DoS, "NeighborhoodSize", opts.NeighSize);
end

im_res = im2uint8(im_res);


if opts.save
    imwrite(im_res, sprintf("%s/%s_guided.png", ...
        opts.path, opts.name));
end

end

