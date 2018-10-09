clear all
mat_dir = 'mat_labels/';
save_dir = 'labels_/';
height = 2160;
width = 4096;

mat = dir(strcat(mat_dir,'*.mat')); 
for q = 1:length(mat)
    
    load(fullfile(mat_dir,mat(q).name));
    
    mask_lines = zeros(height, width);
    nlines = length(mask_points);
    for i=1:nlines
        mask_lines = draw_line_mask(mask_lines, mask_points(i).point1, mask_points(i).point2);  
    end
    mask_lines = imdilate(mask_lines, strel('square',5));
    
    mask_roads = zeros(height, width);
    nroads = length(road_points);
    for i=1:nroads
        mask_roads = draw_poly_mask(mask_roads, road_points(i).points);  
    end
    
    mask_png = zeros(height, width);
    mask_png(logical(mask_lines)) = 1;
    mask_png(logical(mask_roads)) = 2;
    
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

function [new_mask] = draw_poly_mask(mask, vpoints)

[nrows,ncols] = size(mask);
[X,Y] = meshgrid(1:ncols, 1:nrows);

n_vpoints = length(vpoints);
xv = zeros(1,n_vpoints);
yv = zeros(1,n_vpoints);
for i=1:n_vpoints
    point = vpoints(i,:);
    xv(i) = point(1);
    yv(i) = point(2);
end

new_mask = inpolygon(X,Y,xv,yv);


end
