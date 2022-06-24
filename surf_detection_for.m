function [arrey] = surf_detection_for(x_start,img,arrey)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
for index=x_start:250
    arrey(x_start)=surf_detection_trial(img,x_start);
end