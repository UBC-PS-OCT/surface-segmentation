function [arrey] = surf_detetcion_recur(x_start,img,arrey)
%x_start is the starting point on the picture (usually 0)
%arrey is a 1d empty matrix with size of 250
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
arrey(x_start)=surf_detection_trial(img,x_start);
if(x_start<251)
    x_start=x_start+1;
    r=surf_detetcion_recur(x_start,img);
else
    r=0;
end
