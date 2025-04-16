function remove_artifacts_dataset(dataset, method, opts)
%REMOVE_ARTIFACTS_DATASET function to process dataset
% dataset - structure with information about the dataset
% - result - path for the result files
% - filepath - path to the folder with the images
% - filetype - type of the file (for example tif, png)
% opts - structure with parameters for the method
% method - the name of the method
% returns result_table - table with results
% INFO: file will be saved as method_raw.csv, method_stats_psnr.csv,
% method_stats_ssim.csv
% INFO: if result folder does not exist it will be created

if ~exist(dataset.result, 'dir')
    mkdir(dataset.result)
end

% read dataset
path=sprintf("%s*.%s",dataset.filepath,dataset.filetype);
im_files = dir(path);

labels = dir(dataset.labels);

for idx=1:length(im_files)
    [im_org, name] = load_image(im_files(idx));
    l_name = [labels(idx).folder '/' labels(idx).name];
    label = load(l_name);
    opts.label=double(label.inst_map);
    opts.name=name;
    im = process_image(im_org,opts, method,false);
    res_name = sprintf("%s/%s.%s", dataset.result, name, dataset.filetype);
    imwrite(im, res_name,dataset.filetype);
end


