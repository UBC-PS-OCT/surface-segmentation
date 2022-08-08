imagefiles = dir('*.png');      
nfiles = length(imagefiles);    % Number of files found
for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   images{ii} = currentfilename;
end

for t=35:40
    I = imread(images{t});

    surf1 = zeros(1, size(I, 2));
    surf2 = zeros(1, size(I, 2));
    
    %image filtering
    I = imgaussfilt(I);
    I = imadjust(I, [0.15,1]);
    imbw = imbinarize(I);
    im_opened = bwareaopen(imbw, 100,8); %600 default
    I = im_opened .* im2double(I);
    
    for i = 1:size(I, 2)
        [point1, point2] = layer_start(I, i);
        surf1(i) = point1;
        surf2(i) = point2;
    end
    
    %%for debugging%%
    % for i = 1:size(I, 2)
    %     try
    %         [point1, point2] = layer_start(image, i);
    %         surf1(i) = point1;
    %         surf2(i) = point2;
    %     catch
    %         disp(i)
    %     end
    % end
    
    
    %smooth the layers
    surf1_smooth = surface_smooth(surf1, 6);
    surf2_smooth = surface_smooth(surf2, 20);
    
    j1 = linspace(1, length(surf1_smooth), length(surf1_smooth));
    j2 = linspace(1, length(surf2_smooth), length(surf2_smooth));
    
    figure('Name', images{t}); imshow(images{t});
    hold on
    plot(j1,surf1_smooth, 'r-', 'linewidth', 2.5)
    hold on
    plot(j2, surf2_smooth, 'r-', 'linewidth', 2.5)
    pause(0.5)
end

