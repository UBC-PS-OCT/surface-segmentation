% image filtering
I = imread('new1.png');
I = imgaussfilt(I);
I = imadjust(I, [0.15,1]);
imbw = imbinarize(I);
im_opened = bwareaopen(imbw, 800,8); %600 default
I = im_opened .* im2double(I);

index = 69;
%figure();imshow(I);hold on;line([index index], [0, size(I,1)], 'Color', 'r')

%setting the vertical sample line (slice)
slice_height = [1 size(I, 1)];    %size(I, 1) = height of image(length of the slice)

%c = improfile(I,xi,yi) returns sampled pixel values along line segments in image I. The endpoints of the line segments have (x, y) coordinates xi and yi.
intensities = improfile(I,[index index],slice_height); %index = slice position

%if the slice is pure black, we exit function and return zero for both layers, which represent no layers
if intensities == zeros (size(I, 1), 1)
    first_layer = 0;
    second_layer = 0;
    return
end

%Find all local max and print intensity graph with them labelled
%y = linspace(x1,x2,n) generates n points between x1 and x2. The spacing between the points is (x2-x1)/(n-1)
x = linspace(1, size(I,1), size(I,1)); 
y = intensities;
%TF = islocalmax(A) returns a logical array whose elements are 1 (true) when a local maximum is detected in the corresponding element of an array, table, or timetable.
TF = islocalmax(y);
%figure(); plot(x, y, x(TF),y(TF),'r*');

%Find derivative of intensity graph
dy = diff(y);
%figure(); plot(dy);

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
 
%plotting
figure(); plot(x, y, 'Linewidth', 2); hold on; plot(x(TF),y(TF),'b*'); hold on; plot(dy); xlim([50 200]);
hold on
plot(peak1_x, y(peak1_x), 'g.', 'MarkerSize', 20)
hold on
plot(peaki_x, y(peaki_x), 'r.', 'MarkerSize', 20)
legend('intensities', 'local max', 'first derivative', 'point on 1st layer', 'point on 2nd layer');

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