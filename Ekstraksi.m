load('target.mat','I')
load('data.mat','I_bw')

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

ciri_data = [metric,eccentricity,mean(Contrast),mean(Correlation),mean(Energy),mean(Homogeneity)];
save('data.mat', 'ciri_data');