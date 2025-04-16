function converted = conv_to_uint8(im)
%CONV_TO_UINT8 function to convert an image to uint8 image
% TIFF file is loaded as uint16 file but BreCaHAD dataset
% should be stored as uint8 images
% im - image
im = double(im);
converted = uint8(im ./ max(max(im)) * 255);
end