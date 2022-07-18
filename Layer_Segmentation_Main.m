%%%  Running this program requires Xin's surface_smooth.m function, layer_start.m function, and layer_search.m function    %%%

rawdatafolder = 'C:\Users\bryan\Desktop\PSOCT program\surface-segmentation\OCT\';
destinationfolder = 'C:\Users\bryan\Desktop\PSOCT program\surface-segmentation\save\';

rawdata = dir(rawdatafolder);  % You are in the folder where images are there
files = files(~[files.isdir]);
N = length(rawdata) ;   

for j = 1:N            % Loop for each image
    %imshow(files(i).name)  % Opens the image 'j'
    image = strcat(rawdatafolder, files(j).name);

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

    % Save the image %
    print(strcat(destinationfolder, files(i).name), '-dpng');
end


%[file, path] = uigetfile('C:\Users\bryan\Desktop\PSOCT program\surface-segmentation\OCT\.png');
%image = strcat(path,file);

%find the beggining of first and second layers

