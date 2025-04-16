% script to process compressed images, result files are saved to the chosen folder
res_name = "gaussian_filtering_0.7";
% folder with compressed files
dataset.filepath = "E:/datasets/data/Images/kumar/test/Images/original/";
dataset.labels = "E:\datasets\data\Images\kumar\test\Labels\*.mat";
dataset.csv = "E:/EPA-ID/Artifacts Removal Plots/Data/segmentation-stats/stats-23-11-2023_90_no_aug/50-epochs/kumar/kumar-test.csv";
%% EPA_ID
dataset.result = sprintf("E:/kumar/%s/test/",res_name);

% filetype (for example "tif", "png")
dataset.filetype = "tif";

% parameters for the method
 opts.Sigma=0.7;
 opts.Size=3;
 opts.T_m=1;
 method='gaussian_filtering';
 opts.save = 1;
 opts.path = sprintf("E:/kumar/%s/steps/test/", res_name);

if ~exist(opts.path, 'dir')
    mkdir(opts.path)
end

remove_artifacts_dataset(dataset, method, opts);
%remove_artifacts_dataset_EPA_ID_fitted(dataset, method, opts);

%%
% folder with compressed files
dataset.filepath = "E:/datasets/data/Images/kumar/train/Images/original/";
dataset.csv = "E:/EPA-ID/Artifacts Removal Plots/Data/segmentation-stats/stats-23-11-2023_90_no_aug/50-epochs/kumar/kumar-train.csv";
dataset.labels = "E:\datasets\data\Images\kumar\train\Labels\*.mat";
%% EPA_ID
dataset.result = sprintf("E:/kumar/%s/train/", res_name);

% filetype (for example "tif", "png")
dataset.filetype = "tif";

% parameters for the method
%  opts.Sigma=0.7;
%  opts.Size=3;
%  opts.T_m=1;
%  method='EPA_ID_HE_Sobel';
%  opts.save = 1;
 opts.path = sprintf("E:/kumar/%s/steps/train/", res_name);

if ~exist(opts.path, 'dir')
    mkdir(opts.path)
end

remove_artifacts_dataset(dataset, method, opts);
%remove_artifacts_dataset_EPA_ID_fitted(dataset, method, opts);

%%
% folder with compressed files
dataset.filepath = "E:/datasets/data/Images/cpm17/test/Images/original/";
dataset.csv = "E:/EPA-ID/Artifacts Removal Plots/Data/segmentation-stats/stats-23-11-2023_90_no_aug/50-epochs/cpm17/cpm17-test.csv";
dataset.labels = "E:\datasets\data\Images\cpm17\test\Labels\*.mat";
%% EPA_ID
dataset.result = sprintf("E:/cpm17/%s/test/", res_name);

% filetype (for example "tif", "png")
dataset.filetype = "png";

% parameters for the method
%  opts.Sigma=0.7;
%  opts.Size=3;
%  opts.T_m=1;
%  method='EPA_ID_HE_Sobel';
%  opts.save = 1;
 opts.path = sprintf("E:/cpm17/%s/steps/test/", res_name);

if ~exist(opts.path, 'dir')
    mkdir(opts.path)
end

remove_artifacts_dataset(dataset, method, opts);
%remove_artifacts_dataset_EPA_ID_fitted(dataset, method, opts);

%%
% folder with compressed files
dataset.filepath = "E:/datasets/data/Images/cpm17/train/Images/original/";
dataset.labels = "E:\datasets\data\Images\cpm17\train\Labels\*.mat";
dataset.csv = "E:/EPA-ID/Artifacts Removal Plots/Data/segmentation-stats/stats-23-11-2023_90_no_aug/50-epochs/cpm17/cpm17-train.csv";
%% EPA_ID
dataset.result = sprintf("E:/cpm17/%s/train/", res_name);

% filetype (for example "tif", "png")
dataset.filetype = "png";

% parameters for the method
%  opts.Sigma=0.7;
%  opts.Size=3;
%  opts.T_m=1;
%  method='EPA_ID_HE_Sobel';
%  opts.save = 1;
 opts.path = sprintf("E:/cpm17/%s/steps/train/", res_name);

if ~exist(opts.path, 'dir')
    mkdir(opts.path)
end

remove_artifacts_dataset(dataset, method, opts);
%remove_artifacts_dataset_EPA_ID_fitted(dataset, method, opts);

%%
%%
% folder with compressed files
dataset.filepath = "E:/cpm15/original/";
dataset.csv = "E:/EPA-ID/Artifacts Removal Plots/Data/segmentation-stats/stats-23-11-2023_90_no_aug/50-epochs/cpm15/cpm15-test.csv";
dataset.result = sprintf("E:/cpm15/%s/", res_name);

% filetype (for example "tif", "png")
dataset.filetype = "png";

% parameters for the method
%  opts.Sigma=0.7;
%  opts.Size=3;
%  opts.T_m=1;
%  method='EPA_ID_HE_Sobel';
%  opts.save = 1;
 opts.path = sprintf("E:/cpm15/%s/steps/", res_name);

if ~exist(opts.path, 'dir')
    mkdir(opts.path)
end

%remove_artifacts_dataset(dataset, method, opts);
remove_artifacts_dataset_EPA_ID_fitted(dataset, method, opts);
