function img = preprocessing(image)
frameRGB = image;
% # Create the gaussian filter with hsize = [5 5] and sigma = 2
G = fspecial('gaussian',[5 5],2);
%# Filter it
frameRGB = imfilter(frameRGB,G,'same');
frameRGB = SkinSegmentHSV(frameRGB);
frameGray = rgb2gray(frameRGB);
[r c] = find(frameGray>0);
frameGray = imcrop(frameGray,[min(c) min(r) max(c)-min(c) max(r)-min(r)]);
frameGray = imresize(frameGray, [256 256]);
img = frameGray;