function im_res = imdiffuse_filtering(im, opts)
%IMDIFUSSE_FILTERING - Anisotropic diffusion filtering, the number of
% iterations and the threshold value are calculated with the imdiffuseest
% function
% INFO: does not support gpuArrays
% im - jpg image (uint8)
% opts - structure with following parameters
% - ConductionMethod - "exponential" or "quadratic"
% - Connectivity - "minimal" or "maximal"
% returns im_res - filtred image

im=im2double(im);

[n, m, d] = size(im);
im_res=zeros(n,m,d,'double');

for i=1:d
    [gradThresh,numIter] = imdiffuseest(im(:,:,i), ...
        "ConductionMethod",opts.ConductionMethod, ...
        "Connectivity",opts.Connectivity);

    im_res(:,:,i) = imdiffusefilt(im(:,:,i),'GradientThreshold', ...
        gradThresh,'NumberOfIterations',numIter, ...
        "ConductionMethod",opts.ConductionMethod, ...
        "Connectivity",opts.Connectivity);
end

im_res = im2uint8(im_res);

if opts.save
    imwrite(im_res, sprintf("%s/%s_im_res.tiff", ...
        opts.path, opts.name));
end

end

