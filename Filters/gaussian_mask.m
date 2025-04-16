function mask = gaussian_mask(sigma_f, size_f)
%gaussian_mask Returns a gaussian filter mask
% Creates a gaussian filter mask with the given size and sigma
mask = images.internal.createGaussianKernel([sigma_f, sigma_f], [size_f, size_f]);
end