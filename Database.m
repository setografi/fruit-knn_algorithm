image_folder = 'buah';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);
ciri_database = zeros(total_images,6);
buah = zeros(total_images,2);
for n = 1:total_images
    full_name = fullfile(image_folder, filenames(n).name);
    I = imread(full_name);
 
    % Color-Based Segmentation Using K-Means Clustering
    cform = makecform('srgb2lab');
    lab = applycform(I,cform);
 
    ab = double(lab(:,:,2:3));
    nrows = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);
 
    nColors = 2;
    [cluster_idx, ~] = kmeans(ab,nColors,'distance','sqEuclidean', ...
        'Replicates',3);
 
    pixel_labels = reshape(cluster_idx,nrows,ncols);
 
    segmented_images = cell(1,3);
    rgb_label = repmat(pixel_labels,[1 1 3]);
 
    for k = 1:nColors
        color = I;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;
    end
 
    area_cluster1 = sum(find(pixel_labels==1));
    area_cluster2 = sum(find(pixel_labels==2));
 
    [~,cluster_min] = min([area_cluster1,area_cluster2]);
 
    I_bw = (pixel_labels==cluster_min);
    I_bw = imfill(I_bw,'holes');
    I_bw = bwareaopen(I_bw,50);
 
    stats = regionprops(I_bw,'Area','Perimeter','Eccentricity');
    area = stats.Area;
    perimeter = stats.Perimeter;
    metric = 4*pi*area/(perimeter^2);
    eccentricity = stats.Eccentricity;
 
    I_gray = rgb2gray(I);
    I_gray(~I_bw) = 0;
 
    pixel_dist = 1;
    GLCM = graycomatrix(I_gray,'Offset',[0 pixel_dist; -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);
    stats = graycoprops(GLCM,{'contrast','correlation','energy','homogeneity'});
    Contrast = stats.Contrast;
    Correlation = stats.Correlation;
    Energy = stats.Energy;
    Homogeneity = stats.Homogeneity;
    ciri_database(n,:) = [metric,eccentricity,mean(Contrast),mean(Correlation),mean(Energy),mean(Homogeneity)];
end
 
save ciri_database ciri_database