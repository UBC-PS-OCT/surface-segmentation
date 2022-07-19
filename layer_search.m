function [starting_pixel] = layer_search(interval, interval_size, dy, peak_x,x)
    max_slope = max(dy(interval(1):interval(2))); 
    x_values = find(dy((peak_x-interval_size):peak_x) == max_slope);
    
    if length(x_values) ~= 1
        x_values = x_values(:,2);
    end

    starting_pixel  = x_values + peak_x - interval_size - 1;
