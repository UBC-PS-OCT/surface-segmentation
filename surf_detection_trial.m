I = imread('test3.png');
I = imgaussfilt(I);

%setting the vertical sample line
x1 = [50 50];           %x1 = [length from top left    length from bottom left]
y1 = [0 size(I,1)];    %size(I, 1) = height of image/length of sample line


intensities = improfile(I,x1,y1);  %find intensity pixels going down the sample line
intensities = intensities(2:end);            %removes the invalid value in beginning

figure
subplot(2,1,1)      %subplot(number of rows, number of columns, figure#)
imshow(I);
hold on
plot(x1,y1,'r')    %plot sample line


%plot intensity graph under picture with sample line
subplot(2,1,2)
plot(intensities(:,1,1),'r')   
xlabel('Pixel # going down the line')
ylabel('Pixel Intensity')

%Find all local max and print intensity graph with them labelled
x2 = linspace(1, size(I,1), size(I,1));
y2 = intensities;
TF = islocalmax(y2);
figure(); plot(x2,y2, x2(TF),y2(TF),'r*');


two_peaks = maxk(y2(TF), 2);     %finding two largest local max from all local max: y2(TF)

peak1_y = two_peaks(1);          %first local max
peak2_y = two_peaks(2);          %second local max

id1 = find(y2 == peak1_y);       %find x for first local max
peak1_x = x2(id1);   

id2 = find(y2 == peak2_y);       %find y for second local max
peak2_x = x2(id2);

% z1 = peak1_x + ((peak2_x - peak1_x)/2);
% disp(round(z1))


%Find derivative of intensity graph and show it
dy=diff(y2)./diff(x2);
dy = dy(:,1);
dy = [0; dy];
figure(); plot(x2(1:end),dy);


interval1 = [peak1_x-15 peak1_x];   %interval to search for start of lay 1

%Search for maximum 
C = zeros(1,numel(interval1)-1);
for k=1:numel(interval1)-1
C(k)=max(dy(interval1(k):interval1(k+1)));
end

id3 = find(dy(:,1) == C(:,1));       
lay1_start = x2(id3);


disp(['Start of layer 1 is pixel ', num2str(lay1_start)])
