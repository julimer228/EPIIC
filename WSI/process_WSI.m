function process_WSI(filepath, blocksize, parallel, res_path, opts)
%processWSI Function to read and process a WSI image
% filepath - WSI localization
% res_path - path for the result image
% blocksize - size of a block for example [1024 1024]
% parallel - use parallel computing toolbox or not
% opts - structure with following parameters:
% - Method - name of the method ("EPIIC", "EPIIC_Sobel")
% - Size - size of a filter kernel
% - Sigma - std of a gaussian filter
% - He - use stain decomposition or not

% load blocked image
wadapter = images.blocked.TIFF();
bim = blockedImage(filepath,Adapter=wadapter); 
info_org = imfinfo(filepath);

% check number of rescaled levels - the number can be different for
% differen WSI images

% convert info to a table 
inf_org_tab  = struct2table(info_org);

% number of layers
num_layers = height(inf_org_tab);

% add original layers indexes to the table
inf_org_tab.order = transpose(1:num_layers);

% sort layers by dimmensions (like in the blockedImage)
inf_org_tab = sortrows(inf_org_tab, 'Height', 'descend');

% extract info about layers to process
emptyCell = cell(1,1);
rows = zeros(num_layers,1, "logical");
for i=1:num_layers
    rows(i) = isequal(inf_org_tab.StripOffsets(i),emptyCell);
end
inf_org_process = inf_org_tab(rows, :);
num_layers_process=height(inf_org_process);

% remove artifacts (block processing)
border = max(opts.Size, 5);

if opts.Method == "EPIIC"
    layer1= apply(bim,...
        @(bs)EPIIC_WSI(bs.Data, opts),"BorderSize", [border border], ...
        "Level",1, "UseParallel",parallel,"OutputLocation", ...
        "processing_wsi_bin\","BlockSize",blocksize);
elseif opts.Method == "EPIIC_Sobel"
     layer1= apply(bim,...
        @(bs)EPIIC_Sobel_WSI(bs.Data, opts),"BorderSize", [border border], ...
        "Level",1, "UseParallel",parallel,"OutputLocation", ...
        "processing_wsi_bin\","BlockSize",blocksize);
else
    disp("Error: Unknown method name. Use EPIIC or EPIIC_Sobel.")
end


% calculate scales for next layers
scales = zeros(num_layers_process-1, 1, "double");

for i=2:num_layers_process
    scales(i-1) = round((inf_org_process(i,:).Height/inf_org_process(i-1,:).Height),2);
end

% due to the large size use TiffLib instead of imwrite
img_name = res_path;
current_layer=gather(layer1);

for i=1:num_layers_process

    if i>1
        current_layer = imresize(current_layer, scales(i-1));
    end 

    info=table2struct(inf_org_tab(i,:));

    if i==1
        img_save = Tiff(img_name,'w8');
    else
        img_save = Tiff(img_name,'a');
    end
    tags.ImageLength = size(current_layer,1);
    tags.ImageWidth = size(current_layer,2);
    tags.Photometric = Tiff.Photometric.RGB;
    tags.BitsPerSample = info.BitsPerSample(1);
    tags.SamplesPerPixel = size(current_layer,3);
    tags.RowsPerStrip = info.RowsPerStrip;
    tags.TileWidth = info.TileWidth;
    tags.TileLength = info.TileLength;
    tags.Compression = Tiff.Compression.LZW;
    tags.ImageDescription = info.ImageDescription;
    tags.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    tags.Software = 'MATLAB';
    tags.MaxSampleValue = info.MaxSampleValue(1);
    tags.MinSampleValue = info.MinSampleValue(1);

    setTag(img_save, tags);
    write(img_save,  current_layer);
    close(img_save) 
end

%% save information layers
if num_layers>num_layers_process
    for i=num_layers_process+1:num_layers
        info=table2struct(inf_org_tab(i,:));
        current_layer=gather(bim, "Level",i);
        imwrite(current_layer,img_name,"tif","WriteMode","append","Description",info.ImageDescription,...
            "RowsPerStrip",info.RowsPerStrip);
    end
end
rmdir("processing_wsi_bin",'s');
end
