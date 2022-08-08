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
        starting_pixel  = peak_x + x_values - 1;
    else
        starting_pixel = x_values + peak_x - interval_size - 1;
    end
end
