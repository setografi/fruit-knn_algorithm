load("ciri_database.mat","ciri_database");
load('data.mat','ciri_data')

image_folder = 'buah';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);

[num,~] = size(ciri_database);
 
dist = zeros(1,num);
for n = 1:num
    data_base = ciri_database(n,:);
    jarak = sum((data_base-ciri_data).^2).^0.5;
    dist(n) = jarak;
end
 
[~,id] = min(dist);
 
if isempty(id)
    set(handles.edit1,'String','Unknown')
else
    full_name = fullfile(image_folder, filenames(id).name);
    true_name = erase(filenames(id).name,'.jpg');
    
    save('hasil.mat',"true_name");
end