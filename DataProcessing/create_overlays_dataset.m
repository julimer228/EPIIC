function create_overlays_dataset(path_results, path_labels, path_pred,path_overlay_org, path_overlay_pred, show, method)
%CREATE_OVERLAYS_DATASET function to process dataset
% - path_results - path for the result files
% - path_labels - path to the folder with labels (ground truth)
% - path_pred - path to the folder with predictions
% - show - show overlays or not
% - method - name of a method (to create a name for an overlay)
% INFO: if result folder does not exist it will be created

if ~exist(path_results, 'dir')
    mkdir(path_results)
end

% get labels
labels = dir(sprintf("%s*.%s",path_labels,'mat'));

% get predictions
predictions = dir(sprintf("%s*.%s",path_pred,'mat'));

for idx=1:length(labels)
    label_name = [labels(idx).folder '/' labels(idx).name];
    label = load(label_name);
    label_inst = uint8(label.inst_map);

    pred_name = [predictions(idx).folder '/' predictions(idx).name];
    pred = load(pred_name);
    pred_inst = uint8(pred.inst_map);

    overlay_classification = create_overlay(label_inst, pred_inst, show);
    
    split_name = strsplit(labels(idx).name, '.');
    res_im_name=string(split_name(1));
    overlay_class_name = sprintf("%s/%s_%s_overlay.%s", path_results, res_im_name,method, 'png');
    imwrite(overlay_classification, overlay_class_name, 'png');
end
