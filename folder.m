files = dir('*.tif') ;  % You are in the folder where images are there 
N = length(files) ;    % Gives total tiff images in the folder 
for i = 1:N            % Loop for each image
imshow(files(i).name)  % Opens the image 'i'
% do what you want %
% Save the image %
end