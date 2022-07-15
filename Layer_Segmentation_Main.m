%%Running this program requires Xin's surface_smooth.m function and surf_detection_trial.m function%%

image = 'image8.png';

%find the beggining of first and second layers
surf1 = [];
surf2 = [];
for i = 1:250
    [point1, point2] = surf_detection_trial(image, i);
    surf1 = [surf1, point1];
    surf2 = [surf2, point2];
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
