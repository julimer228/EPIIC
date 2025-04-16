function im_res = process_image(im,opts, method, gpu)
%PROCESS_IMAGE function to process the image with the chosen method
% im - jpg image (uint8)
% opts - structure with method's parameters
% method - name of the method

if(gpu)
    im = gpuArray(im);
end

switch method
    case 'imbilateral_filtering'
        im_res = imbilateral_filtering(im, opts);
    case 'MMWF'
        im_res=MMWF_2D_filtering(im,opts);
    case 'avg_filtering'
        im_res = avg_filtering(im, opts);
    case 'gaussian_filtering'
        im_res = gaussian_filtering(im, opts);
    case 'median_filtering'
        im_res = median_filtering(im, opts);
    case 'wiener_filtering'
        im_res = wiener_filtering(im, opts);
    case 'guided_filtering'
        im_res = guided_filtering(im, opts);
    case 'non_local_means_filtering'
        im_res = non_local_means_filtering(im, opts);
    case 'imdiffuse_filtering'
        im_res = imdiffuse_filtering(im, opts);
    case "EPIIC_Sobel"
        im_res = EPIIC_Sobel(im,opts);
    case "EPIIC"
        im_res=EPIIC(im, opts);
end

if(gpu)
    im_res = gather(im_res);
end

