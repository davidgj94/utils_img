clear all
json_dir = 'json/';
save_dir = 'mat_labels/';
json_files = dir(json_dir);
for q = 3:length(json_files) 
    json_text = fileread(strcat(json_dir, json_files(q).name));
    json = jsondecode(json_text);
    nobjects = length(json.shapes);
    mask_points = struct(); % puntos de lineas
    road_points = struct();
    i_line = 0;
    i_road = 0;
    for i=1:nobjects
        points = json.shapes(i).points;
        if json.shapes(i).label == "line"
            i_line = i_line + 1;
            mask_points(i_line).point1 = points(1,:) + 1;
            mask_points(i_line).point2 = points(2,:) + 1;
        elseif json.shapes(i).label == "road"
            i_road = i_road + 1;
            road_points(i_road).points = points + 1;
        end
        
    end
    [~,name,~] = fileparts(json_files(q).name);
    save(strcat(save_dir, name), 'mask_points', 'road_points');
end