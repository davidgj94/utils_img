clear all
mat_dir = 'mat_labels/';
save_dir = 'labels_down_1000_/';
height = 544;
width = 1024;

mat = dir(strcat(mat_dir,'*.mat')); 
for q = 1:length(mat)
    mask = zeros(height, width);
    load(fullfile(mat_dir,mat(q).name));
    nlines = length(mask_points);
    for i=1:nlines
        mask = draw_line_mask(mask, mask_points(i).point1, mask_points(i).point2);  
    end
    mask = imdilate(mask, strel('square',5));
    mask_png = zeros(size(mask));
    mask_png(logical(mask)) = 255;
    [~,mask_name,~] = fileparts(mat(q).name);
    imwrite(uint8(mask_png), fullfile(save_dir, strcat(mask_name, '.png')));
end

function [new_mask] = draw_line_mask(mask, point1, point2)

x1 = point1(1);
y1 = point1(2);
x2 = point2(1);
y2 = point2(2);

% Distance (in pixels) between the two endpoints
nPoints = ceil(sqrt((x2 - x1).^2 + (y2 - y1).^2)) + 1;

% Determine x and y locations along the line
xvalues = round(linspace(x1, x2, nPoints));
yvalues = round(linspace(y1, y2, nPoints));

% Replace the relevant values within the mask
new_mask = mask;
new_mask(sub2ind(size(new_mask), yvalues, xvalues)) = 1;

end
