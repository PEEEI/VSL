clear all;
tic
clc;
startNum = 2;
endNum = 7;
timeID = fopen('time_dynamic_15_HOG_LPQ_256.txt','w');
for times=1:10
    
    fld_feature = strcat('dynamic_15_HOG_LPQ_256\',num2str(times));
    mkdir(fld_feature);
    trainID = fopen(strcat(fld_feature,'\train.dat'),'w');
    testID = fopen(strcat(fld_feature,'\test.dat'),'w');
    
    disp(startNum);
    disp(endNum);
    link_Path = 'D:\Studying\Computer Vision\Database\frame_skin\img_gray_v2\256px\dynamic\';
    files = dir(link_Path);
    dirFlags = [files.isdir];
    subFolders = files(dirFlags);
    for label = 3 : length(subFolders)
        subFiles = dir(strcat(link_Path,subFolders(label).name));
        label_Name = str2num(subFolders(label).name(1:3));
        subDirFlags = [subFiles.isdir];
        subSubFolders = subFiles(subDirFlags);
            for sub= 3 : length(subSubFolders)
                path = strcat(link_Path,subFolders(label).name,'\',subSubFolders(sub).name);
                d = dir([path,'\*.bmp']);
                for i= 1: length(d(not([d.isdir])));
                    name = strcat(path,'\',d(i).name);
                    
%                     frameRGB = imread(name);
%                     frameRGB = imresize(frameRGB, [128 128]);
                    %# Create the gaussian filter with hsize = [5 5] and sigma = 2
%                     G = fspecial('gaussian',[5 5],2);
%                     %# Filter it
%                     frameRGB = imfilter(frameRGB,G,'same');
%                    
%                     frameRGB = SkinSegmentHSV(frameRGB);

%                     frameGray = rgb2gray(frameRGB);

                    frameGray = imread(name);
%                     imshow(frameGray );
                    compute_Hog = extractHOGFeatures(frameGray,'CellSize',[16 16]);
                    compute_LPQ = extractLPQFeatures(frameGray);
                    compute_Features = [compute_Hog compute_LPQ];
                    %test data
                    if(startNum < sub)&&(sub < endNum)
                        fprintf(testID,'%01d', label_Name);

                        for k = 1 : length(compute_Features)
                            if(compute_Features(k) ~=0)
                                testData = compute_Features(k);
                                fprintf(testID,' %d:%f', k, testData);
                            end
                        end
                        fprintf(testID,'\n');
                    %train data
                    else
                        fprintf(trainID,'%01d', label_Name);
                        for k = 1 : length(compute_Features)
                            if(compute_Features(k) ~=0)
                                trainData = compute_Features(k); 
                                fprintf(trainID,' %d:%f', k, trainData);
                            end
                        end
                        fprintf(trainID,'\n');               
                    end

                end  
            end 
    end
    
    startNum = endNum - 1;
    endNum = startNum + 5;
    
    fclose(testID);
    fclose(trainID);
    fprintf(timeID,'%d:%f\n', times, toc);
    toc
end
fclose(timeID);
