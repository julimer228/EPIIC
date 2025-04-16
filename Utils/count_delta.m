function delta = count_delta(im_metric, jpg_metric)
delta=(im_metric - jpg_metric) / jpg_metric * 100;
end
