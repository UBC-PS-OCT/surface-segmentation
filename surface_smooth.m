function [ yi ] = surface_smooth( A_surf, edge_thr)
%UNTITLED11 Summary of this function goes here
%% edge_thr is the throshold for the second order difference of surface to gurrantee its smoothness

%   Detailed explanation goes here

y=A_surf;
x=1:length(y);

% for jj=1:Loop
% A_surf1=medfilt1(A_surf);
% p=polyfit(x,A_surf1,order);
% y1=polyval(p,x);
% y_mm=medfilt1(y, 5);
% 
kp0=diff([1,y]);

kp=diff(diff([1,y,1]));
% kp0=diff([1,y_mm]);
% 
% kp=diff(diff([1,y_mm,1]));

x1=find((abs(kp)<edge_thr)&(abs(kp0)<(edge_thr/2)));
pp=1;
pk=0;
while(pk<(length(y)-3)) %-3
  
% A_surf(x1)=y1(x1);
 y_mm=medfilt1(y, 3);  %5
%y_mm=y;
if length(x1)<1
    break;
end
yi = interp1(x1,y_mm(x1),x,'linear','extrap');
kp1=diff([1,yi]);
kp=diff(diff([1,yi,1]));
% figure(pp)
% plot(y);
% hold on;
% plot(yi,'r');
% hold on;
% plot(x1,y(x1),'o');
pp=pp+1;
if (pp>200) %200
    break;
end
y(x1(1):x1(end))=yi(x1(1):x1(end));
x1=find((abs(kp)<edge_thr)&(abs(kp0)<(edge_thr/2)));
% x1=find((abs(kp)<edge_thr));
if (length(x1)<pk)
    break;
end
pk=length(x1);
% end
% surf1=medfilt1(A_surf);
% surf1(surf1<0)=0;
end
%  weights=[0.3, 0.2, 0.1, 0.01, 0.02];
%  interval=0.2;
%  iter=10;
% 
% 
% [yii,xi]=priorSnakeDeform(x, yi, weights, interval, iter);
% yi=yii;
yi=y;


end