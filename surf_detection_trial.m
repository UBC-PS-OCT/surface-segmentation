function first_layer = surf_detection_trial(pic, index)
    I = imread(pic);
    I = imadjust(I, [0.15,1]);
    imbw = imbinarize(I);
    im_opened = bwareaopen(imbw, 800,8); %600 default
    im_clean = im_opened .* im2double(I);
    I = im_clean;


    %setting the vertical sample line
    x1 = [index index];           %x1 = [length from top left    length from bottom left]
    y1 = [0 size(I, 1)];    %size(I, 1) = height of image/length of sample line
    
    
    intensities = improfile(I,x1,y1);  %find intensity pixels going down the sample line
    intensities = intensities(2:end);            %removes the invalid value in beginning
    
    % figure
    % subplot(2,1,1)      %subplot(number of rows, number of columns, figure#)
    % imshow(I);
    % hold on
    % plot(x1,y1,'r')    %plot sample line
    
    
    %plot intensity graph under picture with sample line
    % subplot(2,1,2)
    % plot(intensities(:,1,1),'r')   
    % xlabel('Pixel # going down the line')
    % ylabel('Pixel Intensity')
    
    %Find all local max and print intensity graph with them labelled
    x2 = linspace(1, size(I,1), size(I,1));
    y2 = intensities;
    TF = islocalmax(y2);
    % figure(); plot(x2,y2, x2(TF),y2(TF),'r*');
    
    
    two_peaks = maxk(y2(TF), 12);     %finding two largest local max from all local max: y2(TF)

    peak1_y = two_peaks(1);          %first local max
    % peak2_y = two_peaks(2); 
    % peak3_y = two_peaks(3);           %third peak
    
    id1 = find(y2 == peak1_y);       %find x for first local max
    peak1_x = x2(id1(1));   
    
    for i=2:12
        peaki_y = two_peaks(i);
        idi = find(y2 == peaki_y);       %find x for first local max
        peaki_x = x2(idi(1));
        if abs(peaki_x - peak1_x) > 30
            break
        end
    end
    
    
    % id2 = find(y2 == peak2_y);       %find x for second local max
    % peak2_x = x2(id2(1));
    
    % id4 = find(y2 == peak3_y);       %find x for second local max
    % peak3_x = x2(id4(1));
    % 
    % if (peak2_x - peak1_x) < 10
    %     peak2_x = peak3_x;
    % end
    
    if peak1_x > peaki_x
        peak1_x = peaki_x;
    end
    
    %Find derivative of intensity graph
    dy=diff(y2)./diff(x2);
    
    dy = dy(:,1);  %keep first column since all of them are identical
    
    %figure(); plot(x2(1:249),dy);    
    
    interval1 = [peak1_x-15 peak1_x];   %interval to search for start of lay 1
    
    %Search for maximum slope in the interval above
    max_slope = zeros(1,numel(interval1)-1);
    for k=1:numel(interval1)-1
    max_slope(k)=max(dy(interval1(k):interval1 ...
        (k+1)));
    end
    
    id3 = find(dy((peak1_x-15):peak1_x) == max_slope);
    lay1_start = x2(id3);
    
    if length(lay1_start) ~= 1
        lay1_start = lay1_start(:,2);
    end
   
    first_layer  = lay1_start + peak1_x - 16;
    
%     disp(['Start of layer ' , num2str(index), ' is pixel ', num2str(lay1_start)])


