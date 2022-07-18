function [first_layer, second_layer] = layer_start(pic, index)
    I = imread(pic);
    I = imgaussfilt(I);
    I = imadjust(I, [0.15,1]);
    imbw = imbinarize(I);
    im_opened = bwareaopen(imbw, 800,8); %600 default
    im_clean = im_opened .* im2double(I);
    I = im_clean;

    %setting the vertical sample line (slice)
    %index = slice position
    slice_height = [1 size(I, 1)];    %size(I, 1) = height of image/length of slice
    intensities = improfile(I,[index index],slice_height);  %find intensity of pixels going down the slice
    
    %Find all local max and print intensity graph with them labelled
    x = linspace(1, size(I,1), size(I,1));
    y = intensities;
    TF = islocalmax(y);
    %figure(); plot(x,y, x(TF),y(TF),'r*');
    
    %finds and sorts all local max in decreasing order
    peaks = maxk(y(TF), length(y(TF)));     

    %Find first/highest local max and its x value
    peak1_y = peaks(1);             
    id1 = find(y == peak1_y);      
    peak1_x = x(id1(1));   

    %Find the second highest local max whose x-value 
    %is 30px away from the first
    for i=2:length(y(TF))
        peaki_y = peaks(i);
        idi = find(y == peaki_y);       
        peaki_x = x(idi(1));
        if abs(peaki_x - peak1_x) > 30
            break
        end
    end
    
    % We want peak1_x to represents the first layer. Hence, peak1_x and 
    %peaki_x needs to be swapped if peak1_x > peaki_x.
    if peak1_x > peaki_x
        c = peak1_x;
        peak1_x = peaki_x;
        peaki_x = c;
    end
     
    %Find derivative of intensity graph
    dy=diff(y)./diff(x);
    dy = dy(:,1);  %keep first column since all of them are identical
    
    %figure(); plot(x(1:249),dy);    
    
    %define intervals to search for the beginning of lay1 and lay2
    interval_size = 25;
    interval1 = [peak1_x-interval_size peak1_x];  
    interval2 = [peaki_x-interval_size peaki_x];

    % use layer_search function to find the first and second layer
    first_layer = layer_search(interval1,interval_size,dy,peak1_x,x);
    second_layer = layer_search(interval2,interval_size,dy,peaki_x,x);
