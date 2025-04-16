function [H,E,Res] = HEdeconvolve(img,opt)

if nargin==1
    opt.vec_type = 2;
    opt.draw = false;
    opt.restore = false;
end
opt.draw = false;
switch opt.vec_type
    case 1
        % set of standard values for stain vectors (from python scikit)
        He = [0.651; 0.701; 0.29];
        Eo = [0.216; 0.801; 0.558];
        Res = [0.316; -0.598; 0.737];
    case 2
        % default Color Deconvolution Matrix proposed in Ruifork and Johnston
        He = [0.644211; 0.716556; 0.266844];
        Eo = [0.092789; 0.954111; 0.283111];
        Res = [-0.051733909968; -0.157623032505; 0.548160286737];
end

% combine stain vectors to deconvolution matrix
HEtoRGB = [He/norm(He) Eo/norm(Eo) Res/norm(Res)]';
RGBtoHE = inv(HEtoRGB);
    
% separate stains = perform color deconvolution
imgHE = SeparateStains(img, RGBtoHE);
H = imgHE(:,:,1);
E = imgHE(:,:,2);
Res = imgHE(:,:,3);

% % show images
if opt.draw
    figure;
    set(gcf,'color','w');
    subplot(2,4,1); imshow(img); title('Original');
    subplot(2,4,2); imshow(H,[]); title('Hematoxylin');
    subplot(2,4,3); imshow(E,[]); title('Eosin');
    subplot(2,4,4); imshow(Res,[]); title('Residual');

    subplot(2,4,5); imhist(rgb2gray(img)); title('Original');
    subplot(2,4,6); imhist(H); title('Hematoxylin');
    subplot(2,4,7); imhist(E); title('Eosin');
    subplot(2,4,8); imhist(Res); title('Residual');
end

if opt.restore
    % combine stains = restore the original image
    tic
    img_restored = RecombineStains(imgHE,HEtoRGB);
    toc
    if opt.draw
        figure;
        subplot(2,2,1); imshow(img); title('Orig');
        subplot(2,2,2); imshow(img_restored); title('restored');
    end
end



function imageRGB = SeparateStains(imageRGB, Matrix)
% color deconvolution project by Jakob Nikolas Kather, 2015
% contact: www.kather.me

% convert input image to double precision float
% add 1 to avoid artifacts of log transformation
imageRGB = double(imageRGB)+1;

% perform color deconvolution
siz = size(imageRGB);
imageRGB = reshape(-log(imageRGB),[],3) * Matrix;
imageRGB = reshape(imageRGB, siz);

% post-processing
imageRGB = normalizeImage(imageRGB,'stretch');

function imageOut = normalizeImage(imageOut, opt)
% color deconvolution project by Jakob Nikolas Kather, 2015
% contact: www.kather.me
for i=1:size(imageOut,3)
    % normalize output range to 0...1
    minn = min(min(imageOut(:,:,i)));
    maxx = max(max(imageOut(:,:,i)));
    imageOut(:,:,i) = (imageOut(:,:,i)-minn)/(maxx-minn);

    % invert image
    imageOut(:,:,i) = 1 - imageOut(:,:,i);

    % optional: stretch histogram
    if strcmp(opt,'stretch')
        if numel(imageOut(:,:,i)) < 1e7
            imageOut(:,:,i) = imadjust(imageOut(:,:,i),stretchlim(imageOut(:,:,i)),[]);
        else
            imageOut(:,:,i) = imadjust_block(imageOut(:,:,i));
        end
    end
end

function imageOut = imadjust_block(imageOut)
%imadjust for large images by block processing

% Compute histogram for intensity
int_hist = imhist(imageOut);

% Compute the CDF of each histogram and prepare to call imadjust
computeCDF = @(histogram) cumsum(histogram) / sum(histogram);
findLowerLimit = @(cdf) find(cdf > 0.01, 1, 'first');
findUpperLimit = @(cdf) find(cdf >= 0.99, 1, 'first');
int_cdf = computeCDF(int_hist);
int_limits(1) = findLowerLimit(int_cdf);
int_limits(2) = findUpperLimit(int_cdf);
int_limits = (int_limits - 1)/255;

% Use blockproc to adjust the image
adjustFcn = @(block) imadjust(block.data,int_limits);
imageOut = blockproc(imageOut,[200 200],adjustFcn);