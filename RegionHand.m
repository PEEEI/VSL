function img = RegionHand(path)
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.) 
%path = 'frame_00028.JPG';
image = imread(path);
%Filter Gausssian
G = fspecial('gaussian',[5 5],2);
image = imfilter(image,G,'same');
%Segmentation Skin
image = SkinSegmentHSV(image);
frameGray = double(rgb2gray(image));

BW = im2bw(frameGray);
BW = bwmorph(BW,'skel');
BW = bwareaopen(BW,2000);

% Label the image
labeledImage = bwlabel(BW);
measurements = regionprops(labeledImage, 'BoundingBox', 'Area');

% Let's extract the second biggest blob - that will be the hand.

% fh = figure;
allAreas = [measurements.Area];
[sortedAreas, sortingIndexes] = sort(allAreas, 'descend');
thisBB = measurements(sortingIndexes(1)).BoundingBox; 
% imshow(image, 'border', 'tight' );
% rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
%     'EdgeColor','r','LineWidth',2 );
%frm = getframe( fh ); %// get the image+rectangle
%imwrite( frm.cdata, 'savedFileName.png' ); %// save to file

%calculate 

img = image;
img(:,:,1) = image(:,:,1).*uint8(BW(:,:));
img(:,:,2) = image(:,:,2).*uint8(BW(:,:));
img(:,:,3) = image(:,:,3).*uint8(BW(:,:));

icrop = imcrop(img,thisBB);
img = icrop;%-img;
%imwrite(img,'dnsavedFileName.png');
end