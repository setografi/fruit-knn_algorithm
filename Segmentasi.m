% Color-Based Segmentation Using K-Means Clustering
load('data.mat','I')
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

save('data.mat', 'I_bw');