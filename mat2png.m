clear all
close all

cd labels_plataforma_lines
mat = dir('*.mat'); 
for q = 1:length(mat) 
    load(mat(q).name);
    figure;
    imshow(mask)
    mask_png = zeros(size(mask));
    mask_png(logical(mask)) = 1;
    imwrite(uint8(mask_png), fullfile('png', strcat(mat(q).name, '.png')));
end