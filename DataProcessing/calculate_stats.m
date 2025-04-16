function [tab_res_ssim, tab_res_psnr] = calculate_stats(tab)
%CALCULATE_STATS Function to calculate statistics
% tab - table with raw data
l=length(tab.Properties.VariableNames);
groupvars = {tab.Properties.VariableNames{8:l}};
tab_res = grpstats(tab,["Q",groupvars],["mean", "std", "var","meanci"],"DataVars",["psnr","ssim","ssim_jpg","psnr_jpg"]);

tab_res_ssim = sortrows(tab_res,"mean_ssim","descend");
tab_res_ssim = sortrows(tab_res_ssim,"Q","ascend");

tab_res_psnr = sortrows(tab_res,"mean_psnr","descend");
tab_res_psnr = sortrows(tab_res_psnr,"Q","ascend");

end

