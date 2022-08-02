function [first_layer, second_layer] = layer_start(pic, index)

% filtering image%
I = image_filter(pic);

%setting the vertical sample line (slice)
%index = slice position
slice_height = [1 size(I, 1)];    %size(I, 1) = height of image/length of slice
intensities = improfile(I,[index index],slice_height);  %find intensity of pixels going down the slice

%if the slice is pure black, we exit function and return
%zero for both layers, which represent no layers
if intensities == zeros (size(I, 1), 1)
    first_layer = 0;
    second_layer = 0;
    return
end

%Find all local max and print intensity graph with them labelled
x = linspace(1, size(I,2), size(I,2));
y = intensities;
TF = islocalmax(y);
%figure(); plot(x,y, x(TF),y(TF),'r*');

%Find derivative of intensity graph
dy = diff(y)./diff(x);
dy = dy(:,1);  %keep first column since all of them are identical
%figure(); plot(x(1:249),dy);  

%finds and sorts all local max in decreasing order
peaks = maxk(y(TF), length(y(TF)));     

%Find first/highest local max and its x value           
id1 = find(y == peaks(1));      
peak1_x = id1(1);   

%if there is only one peak, find first layer and exit function
if length(y(TF)) == 1
    interval_size = 25;
    interval1 = [peak1_x-interval_size peak1_x];    
    first_layer = layer_search(interval1,interval_size,dy,peak1_x);
    second_layer = 0;
    return
end

%Find the second highest local max whose x-value 
%is 30px away from the first
for i=2:length(y(TF))
    peaki_y = peaks(i);
    idi = find(y == peaki_y);       
    peaki_x = idi(1);
    if abs(peaki_x - peak1_x) > 30 
        break
    end
end

% We want peak1_x to represents the first layer. Hence, peak1_x and 
%peaki_x needs to be swaped if peak1_x > peaki_x.
if peak1_x > peaki_x
    c = peak1_x;
    peak1_x = peaki_x;
    peaki_x = c;
end
 

%define intervals to search for the beginning of lay1 and lay2
interval_size = 25;
interval1 = [peak1_x-interval_size peak1_x];  
interval2 = [peaki_x-interval_size peaki_x];

if interval1(1)<0
    interval1(1)=0;
end

count=0;
flag=0;
if abs(peaki_x-peak1_x) < 30
    first_layer = layer_search(interval1,interval_size,dy,peak1_x);
    second_layer = size(I,1);
    return
elseif abs(peaki_x - peak1_x) > 140
    first_layer = layer_search(interval2,interval_size,dy,peaki_x);
    second_layer = size(I, 1);
    return
end



for i=peak1_x:peaki_x
    if(intensities(i)<0.3) %find a better grey scale threshold (need to find threshold)
        count=count+1;
    else
        count=0;
    end
    if count>2
        flag=1;
        break
    end
end


if flag==1
    first_layer = layer_search(interval1,interval_size,dy,peak1_x);
    second_layer = layer_search(interval2,interval_size,dy,peaki_x);
else 
    first_layer = layer_search(interval1,interval_size,dy,peak1_x);
    second_layer = 0;
end


%     first_layer = layer_search(interval1,interval_size,dy,peak1_x,x);
%     second_layer = layer_search(interval2,interval_size,dy,peaki_x,x);
