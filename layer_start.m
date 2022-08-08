function [first_layer, second_layer] = layer_start(I, index)

%setting the vertical sample line (slice)
%index = slice position
slice_height = [1 size(I, 1)];    %size(I, 1) = height of image/length of slice
intensities = improfile(I,[index index],slice_height);  %find intensity of pixels going down the slice

%if the slice is pure black, we exit function and return
%zero for both layers, which represent no layers
if intensities == zeros (size(I, 1), 1)
    first_layer = NaN;
    second_layer = NaN;
    return
end

%Find all local max and print intensity graph with them labelled
x = linspace(1, size(I,2), size(I,2));
y = intensities;
TF = islocalmax(y);

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
    interval_size = 10;
    interval1 = [peak1_x peak1_x+interval_size];  
    if interval1(1)<0
        interval1(1)=0;
    end
    
    if interval1(2) > length(dy)
        interval1(2) = length(dy);
    end
    first_layer = layer_search(interval1, dy, peak1_x, interval_size, 1);
    second_layer = NaN;
    return
end

%Find the second highest local max whose x-value 
%is 30px away from the first
for i=2:length(y(TF))
    peaki_y = peaks(i);
    idi = find(y == peaki_y);
    if length(idi) > 1
        for j=1:length(idi)
            peaki_x = idi(j);
            if abs(peaki_x - peak1_x) > 30
                break
            end
        end
    else
        peaki_x = idi;
    end
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
 
% %define intervals to search for the beginning of lay1 and lay2
interval_size = 10;
interval1 = [peak1_x peak1_x + interval_size];  
interval2 = [peaki_x-interval_size peaki_x ];

if interval1(1)<0
    interval1(1)=0;
end

if interval1(2) > length(dy)
    interval1(2) = length(dy);
end


if interval2(1)<0
    interval2(1)=0;
end

if interval2(2) > length(dy)
    interval2(2) = length(dy);
end

count=0;
flag=0;


if abs(peaki_x-peak1_x) < 30
    first_layer = layer_search(interval1, dy, peak1_x,interval_size, 1);
    second_layer = NaN;
    return
elseif abs(peaki_x - peak1_x) > 140
    first_layer = layer_search(interval2, dy, peaki_x, interval_size, 2);
    second_layer = NaN;
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
    first_layer = layer_search(interval1,dy,peak1_x, interval_size, 1);
    second_layer = layer_search(interval2,dy,peaki_x, interval_size, 2);
else 
    first_layer = layer_search(interval1,dy,peak1_x,interval_size, 1);
    second_layer = NaN;
end
end



function [starting_pixel] = layer_search(interval, dy, peak_x, interval_size, layer_num)
    if layer_num == 1
        max_slope = min(dy(interval(1): interval(2)));
    else
        max_slope = max(dy(interval(1): interval(2)));
    end
    
    x_values = find(dy(interval(1): interval(2)) == max_slope);
    if length(x_values) ~= 1
        x_values = x_values(1);
    end
    
    if layer_num == 1
        starting_pixel  = peak_x + x_values - 1 - 10;
    else
        starting_pixel = x_values + peak_x - interval_size - 1;
    end
end
