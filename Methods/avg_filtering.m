function im_res = avg_filtering(im,opts)
%AVG_FILTERING function to perform filtering with average filter
% im - jpg image (uint8)
% opts - structure with following parameters
% - Size - size of the filter
% returns im_res the image after filtering
im = im2double(im);
filter_mask=avg_mask(opts.Size);
im_res = imfilter(im, ...
    filter_mask, 'symmetric', 'conv');
im_res = im2uint8(im_res);


if opts.save
    imwrite(im_res, sprintf("%s/%s_im_res.tiff", ...
        opts.path, opts.name));
end
end

