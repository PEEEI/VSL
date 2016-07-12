clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear; 
dirfolder = 'output_8_keyframe/01/';
dirname = dir(dirfolder);

 mkdir('_skin');
for j = 1: size(dirname,1)
    %% make directory
    if strcmp(dirname(j).name,'.')==1|| strcmp(dirname(j).name,'..')==1
        continue;
    end
    dir_newname = '_skin/';
    dir_newname_ = strcat(dirname(j).name,'_skin/');
    dir_newname = strcat(dir_newname,dir_newname_);
    mkdir(dir_newname);
    
    dir_sub = dir(strcat(dirfolder,strcat(dirname(j).name,'/')));
    filename = ~[dir_sub(:).isdir];
    filename = dir_sub(filename==1);
    
    for i=1:size(filename,1)
        name1 = strcat(dirname(j).name,'/');
        name = strcat(dirfolder,name1);
        name = strcat(name,filename(i).name);
        image = imread(name);
        image = SkinSegmentHSV(image);
        frameGray = double(rgb2gray(image));
        BW = im2bw(frameGray);

        % Label the image
        labeledImage = bwlabel(BW);
        measurements = regionprops(labeledImage, 'BoundingBox', 'Area');

       % st = regionprops(BW, 'BoundingBox','Area' ); 
        for k = 1 : length(measurements) 
            thisBB = measurements(k).BoundingBox; 
           % rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],... 
           %     'EdgeColor','r','LineWidth',2 ); 
        end
        % Let's extract the second biggest blob - that will be the hand.
        allAreas = [measurements.Area];
        [sortedAreas, sortingIndexes] = sort(allAreas, 'descend');
        if length(sortingIndexes)>2
          handIndex1 = sortingIndexes(2); % The hand is the second biggest, face is biggest.
          handIndex2 = sortingIndexes(3);
          % Use ismember() to extact the hand from the labeled image.
          handImage1 = ismember(labeledImage, handIndex1) ;
          handImage2 = ismember(labeledImage, handIndex2) ;
          % Now binarize
          handImage = (handImage1 > 0) + (handImage2 > 0);
        elseif length(sortingIndexes) == 2
          handIndex1= sortingIndexes(2); 
           % Use ismember() to extact the hand from the labeled image.
          handImage1 = ismember(labeledImage, handIndex1) ;
           % Now binarize
          handImage = (handImage1 > 0);
         
        else
          handIndex1= sortingIndexes(1); 
           % Use ismember() to extact the hand from the labeled image.
          handImage1 = ismember(labeledImage, handIndex1) ;
           % Now binarize
          handImage = (handImage1 > 0);
        end
       
        img = image;
        img(:,:,1) = image(:,:,1).*uint8(handImage(:,:));
        img(:,:,2) = image(:,:,2).*uint8(handImage(:,:));
        img(:,:,3) = image(:,:,3).*uint8(handImage(:,:));
        
%         thisBB = measurements(sortingIndexes(2)).BoundingBox;
%         rectangle('Position', [thisBB(1), thisBB(2),thisBB(3) , thisBB(4)],...
%          'EdgeColor','b','LineWidth',2 );
     
        new_file = strcat(dir_newname,'/');
        new_file = strcat(strcat(new_file,num2str(i)),'_b.bmp');
        imwrite(img,new_file);
    end
end