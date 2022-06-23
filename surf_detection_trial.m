I = imread('image1.png');

%Since size(I,2)/2 = 215.5, I have set the value '215' directly for x
%x = [top bottom]
x1 = [50 50];
y1 = [0 size(I,1)];

c = improfile(I,x1,y1);
figure
subplot(2,1,1)
imshow(I);
hold on
plot(x1,y1,'r')  %plot sample line


subplot(2,1,2)
plot(c(:,1,1),'r')

x2 = linspace(0, size(I,1), size(I,1) +1);
y2 = c(:,1,1);

TF = islocalmax(y2);
figure(); plot(x2,y2, x2(TF),y2(TF),'r*');

y_localmax_list = y2(TF);

two_peaks = maxk(y_localmax_list, 2);

peak1_y = two_peaks(1);
peak2_y = two_peaks(2);

id1 = find(y2 == peak1_y);
peak1_x = x2(id1);

id2 = find(y2 == peak2_y);
peak2_x = x2(id2);

z1 = peak1_x + ((peak2_x - peak1_x)/2);
disp(round(z1))







