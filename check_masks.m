mask_dir = 'labels_down_850/';
imgs_dir = 'imgs_down_850/';

m = dir(mask_dir);
n = dir(imgs_dir);

for q = 3:length(m) 
    mask = logical(imread(strcat(mask_dir, m(q).name)));
    img = imread(strcat(imgs_dir, n(q).name));
    blended = blend_img(img, mask, 0.6);
    figure, imshow(blended);
    pause(3);
end

function [blended_img] = blend_img(img, mask, alpha)
    sz = size(mask);
    red_mask = zeros(sz);
    red_mask(logical(mask)) = 255;
    green_mask = zeros(sz);
    blue_mask = zeros(sz);
    color_mask = uint8(cat(3, red_mask(:,:,1), green_mask(:,:,1), blue_mask(:,:,1)));
    blended_img = alpha * img + (1- alpha) * color_mask;
end