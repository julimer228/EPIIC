function jpg = compress_image(image, q)
%READ_IMAGE
% Function to load the image
% image - image to compress
% q - quality factor (0-100)
% returns jpg - compressed image
imwrite(image, 'jpg_conv.jpg', 'jpg', 'Quality', q);
jpg = imread('jpg_conv.jpg');
delete('jpg_conv.jpg');
end