%%%  Running this program requires Xin's surface_smooth.m function, layer_start.m function, and layer_search.m function    %%%

image = 'image8.png';

%find the beggining of first and second layers
surf1 = zeros(1,250);
surf2 = zeros(1,250);
for i = 1:250
    [point1, point2] = layer_start(image, i);
    surf1(i) = point1;
    surf2(i) = point2;
end

%smooth both layers
surf1_smooth = surface_smooth(surf1, 6);
surf2_smooth = surface_smooth(surf2, 60);

j = linspace(1,250,250);

%plot original picture with the two layers
figure('Name', image); imshow(image);
hold on
plot(j,surf1_smooth, 'r-', 'linewidth', 2.5)
hold on
plot(j, surf2_smooth, 'r-', 'linewidth', 2.5)
