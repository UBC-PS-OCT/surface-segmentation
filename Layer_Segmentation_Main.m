imagefiles = dir('*.png');
count = 0;
nfiles = length(imagefiles);    % Number of files found
for ii=1:nfiles
    currentfilename = imagefiles(ii).name;
    images{ii} = currentfilename;
end

%%initialize the 2d matrix for x-zcoordinates
twodmat1=zeros(nfiles);
twodmat2=zeros(nfiles);
%%changed
for t=100:130 
     try
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
        
%%store everything in the 2dmat
        for i=1:size(surf1,2)
            twodmat1(i,t)=surf1(i);
            twodmat2(i,t)=surf2(i);
        end 
%%changed 


%         j1 = linspace(1, length(surf1_smooth), length(surf1_smooth));
%         j2 = linspace(1, length(surf2_smooth), length(surf2_smooth));
% 
%             figure('Name', images{t}); imshow(images{t});
%             hold on
%             plot(j1,surf1_smooth, 'r-', 'linewidth', 2.5)
%             hold on
%             plot(j2, surf2_smooth, 'r-', 'linewidth', 2.5)
%             pause(0.5)


    catch
        disp(t)
        count = count + 1;
    end
end

%%smooth the 2 segmentation along z
for i=1:size(surf1,2)
    twodmat1(i,:)=surface_smooth(twodmat1(i,:),6);
    twodmat2(i,:)=surface_smooth(twodmat2(i,:),20);
end

%%plot
for t=100:130
    for i=1:size(surf1,2)
    surf1_smooth(i,:)=twodmat1(i,t);
    surf2_smooth(i,:)=twodmat2(i,t);
    end
        j1 = linspace(1, length(surf1_smooth), length(surf1_smooth));
        j2 = linspace(1, length(surf2_smooth), length(surf2_smooth));

            figure('Name', images{t}); imshow(images{t});
            hold on
            plot(j1,surf1_smooth, 'r-', 'linewidth', 2.5)
            hold on
            plot(j2, surf2_smooth, 'r-', 'linewidth', 2.5)
            pause(0.5)
end 
%%changed

disp(count)
disp(count/nfiles)

