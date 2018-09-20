function mask_points = readPoints(image_path, mask_name, mask_points)
%readPoints   Read manually-defined points from image
%   POINTS = READPOINTS(IMAGE) displays the image in the current figure,
%   then records the position of each click of button 1 of the mouse in the
%   figure, and stops when another button is clicked. The track of points
%   is drawn as it goes along. The result is a 2 x NPOINTS matrix; each
%   column is [X; Y] for one point.
% 
%   POINTS = READPOINTS(IMAGE, N) reads up to N points only.

image = imread(image_path);
imshow(image);     % display image
xold = 0;
yold = 0;
hold on;           % and keep it there while we plot

if nargin < 3
    mask_points = struct();
    k= 0;
elseif nargin == 3
    resume_session(mask_points);
    k = length(mask_points);
end

while 1
    
    [xi, yi, but] = ginput(1);      % get a point
    
    if ~isempty(xi) && ~isempty(yi)
        x = xi;
        y = yi;
    end
    
    if but==115 % s guardar
        save(strcat('labels_plataforma_lines/', mask_name), 'mask_points')
    elseif but==105 % i salir
        hold off
        save(strcat('labels_plataforma_lines/', mask_name), 'mask_points')
        break
    elseif but==111 % o desfijar punto
        xold = 0;
        yold = 0;
    elseif but==116 % t zoom in
        ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
        axis([x-width/2 x+width/2 y-height/2 y+height/2]);
        zoom(2);
    elseif but==121 % y zoom out
        ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
        axis([x-width/2 x+width/2 y-height/2 y+height/2]);
        zoom(1/2);
    elseif but==117% u fijar punto/pintar linea
        
        ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
        axis([x-width/2 x+width/2 y-height/2 y+height/2]);
        
        if xold
            k = k + 1;
            mask_points(k).point1 = [xold yold];
            mask_points(k).point2 = [x y];
            plot([xold x], [yold y], 'go-');  % draw as we go
        else
            plot(x, y, 'go');         % first point on its own
        end
        
        xold = x;
        yold = y;
        
    end
    
end

end

function [] = resume_session(mask_points)
nlines = length(mask_points);
for i=1:nlines
    x1 = mask_points(i).point1(1);
    y1 = mask_points(i).point1(2);
    x2 = mask_points(i).point2(1);
    y2 = mask_points(i).point2(2);
    plot([x1 x2], [y1 y2], 'go-');
end
end

% function [new_mask] = draw_line_mask(mask, point1, point2)
% 
% x1 = point1(1);
% y1 = point1(2);
% x2 = point2(1);
% y2 = point2(2);
% 
% % Distance (in pixels) between the two endpoints
% nPoints = ceil(sqrt((x2 - x1).^2 + (y2 - y1).^2)) + 1;
% 
% % Determine x and y locations along the line
% xvalues = round(linspace(x1, x2, nPoints));
% yvalues = round(linspace(y1, y2, nPoints));
% 
% % Replace the relevant values within the mask
% new_mask = mask;
% new_mask(sub2ind(size(new_mask), yvalues, xvalues)) = 1;
% 
% end
% 
% function [blended_img] = blend_img(img, mask, alpha)
%     sz = size(mask);
%     red_mask = zeros(sz);
%     red_mask(logical(mask)) = 255;
%     green_mask = zeros(sz);
%     blue_mask = zeros(sz);
%     color_mask = uint8(cat(3, red_mask(:,:,1), green_mask(:,:,1), blue_mask(:,:,1)));
%     blended_img = alpha * img + (1- alpha) * color_mask;
% end
