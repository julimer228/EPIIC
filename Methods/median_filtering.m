function im_res = median_filtering(im,opts)
%MEDIAN_FILTERING function to perform filtering with wiener filter
% im - jpg image (uint8)
% opts - structure with following parameters
% - Size - size of the filter
% returns im_res - filtred image

im = im2double(im);
[n, m, d] = size(im);
im_res=zeros(n,m,d,'double');
for i=1:d
    im_res(:,:,i) = medfilt2(im(:,:,i), [opts.Size opts.Size]);
end

im_res = im2uint8(im_res);


if opts.save
    imwrite(im_res, sprintf("%s/%s_im_res.tiff", ...
        opts.path, opts.name));
end

end

