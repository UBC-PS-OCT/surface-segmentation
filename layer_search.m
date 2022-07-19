function [starting_pixel] = layer_search(interval, interval_size, dy, peak_x,x)
    max_slope = max(dy(interval(1):interval(2)));
    
    id3 = find(dy((peak_x-interval_size):peak_x) == max_slope);
    lay_start = x(id3);
    
    if length(lay_start) ~= 1
        lay_start = lay_start(:,2);
    end

    starting_pixel  = lay_start + peak_x - interval_size - 1;
