function im_res = MMWF_2D_filtering(im,opts)
%MMWF_2D_FILTERING Median Modified Wiener filter
% INFO: - gpuArrays - time consuming
% im - jpg image (uint8)
% opts - structure with following parameters
% - Size - filter size (odd number)
% - Filter - "MMWF","MMWF*" - filter type
% returns im_res - filtred image

im = im2double(im);

[n, m, d] = size(im);
im_res1 = zeros(n, m, d, 'double');
im_res2 =  zeros(n, m, d, 'double');

for i=1:d
    [~,~,~,~,im_res1(:,:,i),im_res2(:,:,i)]  = MMWF_2D_website(im(:,:,i), opts.Size);
end

im_res1 = im2uint8(im_res1);
im_res2 = im2uint8(im_res2);

if(opts.Filter == "MMWF")
    im_res = im_res1;
else
    im_res = im_res2;
end

end

