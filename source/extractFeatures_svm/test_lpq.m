clear all;
tic
clc;
startNum = 2;
endNum = 7;
timeID = fopen('time_dynamic_12_lpq__256_0.25.txt','w');
for times=1:10
    fld_feature = strcat('dynamic_12_lpq__256_0.25\',num2str(times));
    mkdir(fld_feature);
    train_LPQ_ID = fopen(strcat(fld_feature ,'\train_LPQ.dat'),'w');   
    test_LPQ_ID = fopen(strcat(fld_feature ,'\test_LPQ.dat'),'w');
    
    disp(startNum);
    disp(endNum);
    link_path = 'D:\Studying\Computer Vision\Database\frame_skin\img_gray_v2\256px\dynamic\';
    files = dir(link_path);
    dirFlags = [files.isdir];
    subFolders = files(dirFlags);
    for label = 3 : length(subFolders)
        subFiles = dir(strcat(link_path,subFolders(label).name));
        label_Name = str2num(subFolders(label).name(1:3));
        subDirFlags = [subFiles.isdir];
        subSubFolders = subFiles(subDirFlags);
            for sub= 3 : length(subSubFolders)
                path = strcat(link_path,subFolders(label).name,'\',subSubFolders(sub).name);
                d = dir([path,'\*.bmp']);
                opticFlow = opticalFlowLK('NoiseThreshold',0.009);
                for i= 1: length(d(not([d.isdir])));
                    name = strcat(path,'\',d(i).name);
%                     frameRGB = imread(name);
%                     frameRGB = imresize(frameRGB, [128 128]);
%                     %# Create the gaussian filter with hsize = [5 5] and sigma = 2
%                     G = fspecial('gaussian',[5 5],2);
%                     %# Filter it
%                     frameRGB = imfilter(frameRGB,G,'same');
%                    
%                     frameRGB = SkinSegmentHSV(frameRGB);
% 
%                     frameGray = rgb2gray(frameRGB);
                      frameGray = imread(name);
                        
                    flow = estimateFlow(opticFlow,frameGray);
%                     imshow(frameGray );
                    compute_LPQ = extractLPQFeatures(frameGray);
                    %test data
                    if(startNum < sub)&&(sub < endNum)
                        fprintf(test_LPQ_ID,'%01d', label_Name);
                        for k = 1 : length(compute_LPQ)
                            if(compute_LPQ(k) ~=0)
                                testData = compute_LPQ(k);
                                fprintf(test_LPQ_ID,' %d:%f', k, testData);
                            end
                        end
                        fprintf(test_LPQ_ID,'\n');              
                    %train data
                    else
                        fprintf(train_LPQ_ID,'%01d', label_Name);
                        for k = 1 : length(compute_LPQ)
                            if(compute_LPQ(k) ~=0)
                                trainData = compute_LPQ(k); 
                                fprintf(train_LPQ_ID,' %d:%f', k, trainData);
                            end
                        end
                        fprintf(train_LPQ_ID,'\n');       
                    end

                end  
            end 
    end
    
    startNum = endNum - 1;
    endNum = startNum + 5;
    
    fclose(train_LPQ_ID);
    fclose(test_LPQ_ID);
    fprintf(timeID,'%d:%f\n', times, toc);
    toc
end
fclose(timeID);