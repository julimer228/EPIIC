function results_table = process_dataset(dataset, method, opts)
%PROCESS_DATASET function to process dataset
% dataset - structure with information about the dataset
% - result - path for the result files
% - Q - quality compression factors vector
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

results_table = table();
% read dataset
path=sprintf("%s*.%s",dataset.filepath, dataset.filetype);
im_files = dir(path);

% create param combinations for data processing
params = create_params(opts);

csv_path = sprintf("%s/%s_raw_.csv",dataset.result, method);

for q = 1:length(dataset.Q)
    for idx=1:length(im_files)

        % read file
        [im_org, name] = load_image(im_files(idx));

        % compress file
        im_jpg = compress_image(im_org,dataset.Q(q));

        % calculate ssim and psnr
        [ssim_jpg, psnr_jpg] = calculate_metrics(im_jpg, im_org);

        Q=dataset.Q(q);
        file_results_table = table();

        % process jpg with chosen method
       parfor p = 1:length(params)
            
            opt_im = params{p};
            opt_im.name = name;
            im = process_image(im_jpg,opt_im, method,false);
            % calculate ssim and psnr
            [ssim, psnr] = calculate_metrics(im, im_org);

            % save results to the table
            params_table = struct2table(params{p});
            new_row = table(name, ssim, psnr, ssim_jpg, psnr_jpg,Q, method,params_table);
            new_row = splitvars(new_row);
            file_results_table = [file_results_table; new_row];
        end
        writetable(file_results_table,csv_path,'WriteMode','append')
        results_table = [results_table; file_results_table];
        disp(Q);
        disp(idx);
    end
end

% save table
csv_path = sprintf("%s/%s_raw_.csv",dataset.result, method);
writetable(results_table, csv_path );

% save stats
[res_ssim, res_psnr] = calculate_stats(results_table);
writetable(res_psnr, sprintf("%s/%s_stats_psnr.csv",dataset.result, method));
writetable(res_ssim, sprintf("%s/%s_stats_ssim.csv",dataset.result, method));

end

