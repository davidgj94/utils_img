clear all
json_dir = 'json/';
save_dir = 'mat_labels/';
json_files = dir(json_dir);
for q = 3:length(json_files) 
    json_text = fileread(strcat(json_dir, json_files(q).name));
    json = jsondecode(json_text);
    nlines = length(json.shapes);
    mask_points = struct();
    for i=1:nlines
        points = json.shapes(i).points;
        mask_points(i).point1 = points(1,:);
        mask_points(i).point2 = points(2,:);
    end
    [~,name,~] = fileparts(json_files(q).name);
    save(strcat(save_dir, name), 'mask_points');
end