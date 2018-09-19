function mask = readPoints(image_path, mask_name, mask_points)
%readPoints   Read manually-defined points from image
%   POINTS = READPOINTS(IMAGE) displays the image in the current figure,
%   then records the position of each click of button 1 of the mouse in the
%   figure, and stops when another button is clicked. The track of points
%   is drawn as it goes along. The result is a 2 x NPOINTS matrix; each
%   column is [X; Y] for one point.
% 
%   POINTS = READPOINTS(IMAGE, N) reads up to N points only.

image = imread(image_path);
[nr, nc, ~] = size(image);
sz = [nr, nc];
imshow(image);     % display image
xold = 0;
yold = 0;
hold on;           % and keep it there while we plot

if nargin < 3
    mask_points = [];
elseif nargin == 3
    resume_session(mask_points, sz);
end

while 1
    
    [xi, yi, but] = ginput(1);      % get a point
%     if but==105                  % stop if not button i
%         hold off
%         mask = imdilate(mask, ones(3, 3));
%         figure
%         imshow(blend_img(image, mask, 0.6));
%         save(strcat('labels_plataforma_lines/', mask_name), 'mask')
%         break
%     end
    
    disp(but)
    
    if ~isempty(xi) && ~isempty(yi)
        x = xi;
        y = yi;
    end
    
    if but==115 % s guardar
        save(strcat('labels_plataforma_lines/', mask_name), 'mask_points')
    elseif but==105 % i salir
        hold off
%         mask = imdilate(mask, ones(3, 3));
%         figure
%         imshow(blend_img(image, mask, 0.6));
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
            ind_old = sub2ind(sz, round(yold), round(xold));
            ind_new = sub2ind(sz, round(y), round(x));
            mask_points = [mask_points; [ind_old ind_new]];
%             mask = draw_line_mask(mask, [xold, yold], [x, y]);
            plot([xold x], [yold y], 'go-');  % draw as we go
        else
            plot(x, y, 'go');         % first point on its own
        end
        
        xold = x;
        yold = y;
        
    end
        
    
    
%     if but==116 || but==121 || but==117 || but==111
%         
%         disp('entro')
%         
%         if but==111
%             xold = 0;
%             yold = 0;
%         else
%             ax = axis; width=ax(2)-ax(1); height=ax(4)-ax(3);
%             axis([x-width/2 x+width/2 y-height/2 y+height/2]);
%         end
%         
%         if but==116 % t
%             disp('entro t')
%             zoom(2);
%         elseif but==121 % y
%             zoom(1/2);    
%         elseif but==117% u
%             
%             if xold
%                 mask = draw_line_mask(mask, [xold, yold], [x, y]);
%                 plot([xold x], [yold y], 'go-');  % draw as we go
%             else
%                 plot(x, y, 'go');         % first point on its own
%             end
%             
%             xold = x;
%             yold = y;
%             
%         end
%        
%     end
    
end

end

function [] = resume_session(mask_points, sz)
nlines = size(mask_points, 1);
for i=1:nlines
    [y1, x1] = ind2sub(sz, mask_points(i,1));
    [y2, x2] = ind2sub(sz, mask_points(i,2));
    plot([x1 x2], [y1 y2], 'go-');  % draw as we go
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
