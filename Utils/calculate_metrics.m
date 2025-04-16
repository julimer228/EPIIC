function [im_ssim, im_psnr] = calculate_metrics(im, im_org)
[ssimVal, ~]=ssim(im, im_org,"DataFormat","SSC");
im_ssim=mean(ssimVal,"all");
im_psnr=psnr(im, im_org, "DataFormat","SSC");
end