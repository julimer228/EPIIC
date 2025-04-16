function [im_org, name] = load_image(file)
% load_image - function to load the image and convert it to uint8
% file - image filepath
% returns im_org - loaded image
% returns name - filename

split_name = strsplit(file.name, '.');
name=string(split_name(1));
f_name = [file.folder '/' file.name];
im_org = imread(f_name);

if isa(im_org,'uint8') == false
    im_org = conv_to_uint8(im_org);
end

end