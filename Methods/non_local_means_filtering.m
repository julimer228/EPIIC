function im_res = non_local_means_filtering(im,opts)
%NON_LOCAL_MEANS_FILTERING filtration using non-local means filtering
% INFO: does not support gpuArrays
% im - jpg image (uint8)
% opts - structure with following parameters

im= im2double(im);
im = rgb2lab(im);

% Filter the noisy L*a*b* image using non-local means filtering.

im_res = imnlmfilt(im);
im_res = lab2rgb(im_res,'Out','double');
im_res = im2uint8(im_res);


if opts.save
    imwrite(im_res, sprintf("%s/%s_im_res.tiff", ...
        opts.path, opts.name));
end

end

