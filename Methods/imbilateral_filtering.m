function im_res = imbilateral_filtering(im, opts)
%IMBILATERAL_FILTERING Bilateral filtering of images with Gaussian kernels
% INFO: does not support gpuArrays
% im - jpg image (uint8)
% opts - structure with following parameters
% - DoS - degree of smoothing multiplier
% - Sigma - Standard deviation of spatial Gaussian smoothing kernel (default = 1)
% returns im_res - filtred image

imLAB = rgb2lab(im);

DoS = opts.DoS;
smoothedLAB = imbilatfilt(imLAB,DoS, opts.Sigma);
im_res = lab2rgb(smoothedLAB,"Out","double");

im_res = im2uint8(im_res);


if opts.save
    imwrite(im_res, sprintf("%s/%s_im_res.tiff", ...
        opts.path, opts.name));
end

end

