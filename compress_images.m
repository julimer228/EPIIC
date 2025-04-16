%COMPRESS_FILES Scritp to compress files with the jpeg algorithm.
% im_path - folder with files to compress
% res_path - folder with results (must be different than im_path)
% filetype - type of files in the folder
% Q - vector of compression quality factors

im_path = "E:\EPA-ID\ArtifactsRemovalCode\Datasets\BreCaHAD\";
res_path = "E:\EPA-ID\ArtifactsRemovalCode\Datasets\Compressed\BreCaHAD\";
filetype = "tif";
Q = 10:10:90;

path=sprintf("%s*.%s",im_path, filetype);
im_files = dir(path);


% set a path for result images
images_folder = strcat(res_path,'\Q');

for i=1:length(Q)
    % Check if folder exists, if not create it
    images_folder_q=strcat(images_folder,string(Q(i)));

    if isfolder(images_folder_q) == false
        mkdir(images_folder_q);
    end

    for ind=1:length(im_files)
        % read an image and convert it into uint8
        im_name = strsplit(im_files(ind).name, '.');
        f_name = [im_files(ind).folder '\' im_files(ind).name];
        im_org = imread(f_name);

        % convert to uint8
        if isa(im_org,'uint8') == false
            im_org = conv_to_uint8(im_org);
        end

        % set image name
        res_name=strcat(images_folder_q,'\',im_name(1),'.jpg');

        % compress to jpg with quality Q
        imwrite(im_org, res_name, 'jpg', 'Quality', Q(i));
    end
end
