%load file
[file, path] = uigetfile('*.png');
im = imread(strcat(path,file));

%image processing
im = imgaussfilt(im);
imbw = imbinarize(im);
im_opened = bwareaopen(imbw, 600,8); %600 default
im_clean = im_opened .* im2double(im);
log_clean = logical(medfilt2(im_clean));

%finding the primary surface
top = arrayfun(@(x)find(log_clean(:,x),1,'first'),1:size(log_clean,2), 'un', 0);
top_filled = cellfun(@replaceEmptyWithZero, top);
top_filled(top_filled == 0) = NaN;
top_mean = movmean(top_filled, 80, 'omitnan');
total_mean = mean(top_filled, 'omitnan');

NaNs = find(isnan(top_filled));
for i = NaNs
    top_filled(i) = total_mean; 
end

surface1 = top_filled;
figure(); imshow(im); hold on; plot(surface1, 'r', 'Linewidth',2); %display primary surface



%finding the secondary surface
for i = 1:size(log_clean,2)
    log_clean(1:surface(i),i) = 1;
end

imbw=imcomplement(log_clean);
im_opened = bwareaopen(imbw, 600,8);%200 default
im_clean = im_opened .* im2double(im);
log_clean = logical(medfilt2(im_clean));

top = arrayfun(@(x)find(log_clean(:,x),1,'first'),1:size(log_clean,2), 'un', 0);
top_filled = cellfun(@replaceEmptyWithZero, top);
top_filled(top_filled == 0) = NaN;
top_mean = movmean(top_filled, 80, 'omitnan');
total_mean = mean(top_filled, 'omitnan');

NaNs = find(isnan(top_filled));
for i = NaNs
    top_filled(i) = total_mean; 
end

for i = 1:size(log_clean,2)
    log_clean(1:surface(i),i) = 1;
end
imbw=imcomplement(log_clean);
im_opened = bwareaopen(imbw, 600,8);%200 default
im_clean = im_opened .* im2double(im);
log_clean = logical(medfilt2(im_clean));

top = arrayfun(@(x)find(log_clean(:,x),1,'first'),1:size(log_clean,2), 'un', 0);
top_filled = cellfun(@replaceEmptyWithZero, top);
top_filled(top_filled == 0) = NaN;
top_mean = movmean(top_filled, 80, 'omitnan');
total_mean = mean(top_filled, 'omitnan');

NaNs = find(isnan(top_filled));
for i = NaNs
    top_filled(i) = total_mean; 
end

surface2 = top_filled;
hold on; plot(surface2, 'r', 'Linewidth', 2);

function fixed_value = replaceEmptyWithZero(x)
if isempty(x)
    x = 0;
end
fixed_value = x;
end