function img = mul_RegionHand(path)
    clc;    % Clear the command window.
    close all;  % Close all figures (except those of imtool.) 
    %path = 'frame_00048.JPG';
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

    fh = figure;
    allAreas = [measurements.Area];
    [sortedAreas, sortingIndexes] = sort(allAreas, 'descend');
    
    thisBB1 = measurements(sortingIndexes(1)).BoundingBox;
    if length(sortingIndexes) > 2
        thisBB2 = measurements(sortingIndexes(2)).BoundingBox;
        thisBB3 = measurements(sortingIndexes(3)).BoundingBox;
        %imshow(image, 'border', 'tight' );
        %hold on
        %rectangle('Position', [thisBB1(1),thisBB1(2),thisBB1(3),thisBB1(4)],...
        %     'EdgeColor','r','LineWidth',2 );
        %rectangle('Position', [thisBB2(1),thisBB2(2),thisBB2(3),thisBB2(4)],...
        %     'EdgeColor','r','LineWidth',2 );
        %rectangle('Position', [thisBB3(1),thisBB3(2),thisBB2(3),thisBB3(4)],...
        %     'EdgeColor','r','LineWidth',2 );
        x_min = min([thisBB1(1) thisBB2(1) thisBB3(1)]);
        y_min = min([thisBB1(2) thisBB2(2) thisBB3(2)]);
        x_max = max([thisBB1(1)+thisBB1(3) thisBB2(1)+thisBB2(3) thisBB3(1)+thisBB3(3)]);
        y_max = max([thisBB1(2)+thisBB1(4) thisBB2(2)+thisBB2(4) thisBB3(2)+thisBB3(4)]);
        w = x_max-x_min;
        h = y_max-y_min;

        %%Assign
        thisBB(1) = x_min;
        thisBB(2) = y_min;
        thisBB(3) = w;
        thisBB(4) = h;
    elseif length(sortingIndexes) == 2
        thisBB2 = measurements(sortingIndexes(2)).BoundingBox;
        
       % rectangle('Position', [thisBB1(1),thisBB1(2),thisBB1(3),thisBB1(4)],...
       %      'EdgeColor','r','LineWidth',2 );
        %rectangle('Position', [thisBB2(1),thisBB2(2),thisBB2(3),thisBB2(4)],...
         %    'EdgeColor','r','LineWidth',2 );
        
        x_min = min([thisBB1(1) thisBB2(1)]);
        y_min = min([thisBB1(2) thisBB2(2)]);
        x_max = max([thisBB1(1)+thisBB1(3) thisBB2(1)+thisBB2(3)]);
        y_max = max([thisBB1(2)+thisBB1(4) thisBB2(2)+thisBB2(4)]);
        w = x_max-x_min;
        h = y_max-y_min;

        %%Assign
        thisBB(1) = x_min;
        thisBB(2) = y_min;
        thisBB(3) = w;
        thisBB(4) = h;  
    else
        thisBB = thisBB1;
    end
    %rectangle('Position', [x_min, y_min,w , h],...
    %     'EdgeColor','b','LineWidth',2 );

    %frm = getframe( fh ); %// get the image+rectangle
    %imwrite( frm.cdata, 'savedFileName.png' ); %// save to file
    %% calculate 

    img = image;
    img(:,:,1) = image(:,:,1).*uint8(BW(:,:));
    img(:,:,2) = image(:,:,2).*uint8(BW(:,:));
    img(:,:,3) = image(:,:,3).*uint8(BW(:,:));

    icrop = imcrop(img,thisBB);
    img = icrop;%

end
