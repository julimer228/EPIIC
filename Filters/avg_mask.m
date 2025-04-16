function mask = avg_mask(size)
mask = fspecial("average", [size size]);
end