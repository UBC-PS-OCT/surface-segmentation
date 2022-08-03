%%%  Running this program requires Xin's surface_smooth.m function, layer_start.m function, and layer_search.m function    %%%

[file, path] = uigetfile('D:\PS-OCT2\processed\LL_fingerDMG_20220522_021\FullOCT\.png');
image = strcat(path,file);
im = imread(image);

%find the beggining of first and second layers
surf1 = zeros(1, size(im, 1));
surf2 = zeros(1, size(im, 1));
for i = 1:size(im, 1)
    [point1, point2] = layer_start(image, i); %image is passed in as a path
    surf1(i) = point1;
    surf2(i) = point2;
end

%smooth both layers
surf1_smooth = surface_smooth(surf1, 6);
surf2_smooth = surface_smooth(surf2, 60);

j = linspace(1, size(im, 1), size(im, 1));

%plot original picture with the two layers
figure('Name', image); imshow(image);
hold on
plot(j,surf1_smooth, 'r-', 'linewidth', 2.5)
hold on
plot(j, surf2_smooth, 'r-', 'linewidth', 2.5)