clear all;
tic
clc;
startNum = 2;
endNum = 7;
timeID = fopen('time.txt','w');
for times=1:10
    fld_feature = strcat('dynamic_15_lbp_256\',num2str(times));
    mkdir(fld_feature);
    train_LBP_ID = fopen(strcat(fld_feature ,'\train_LBP.dat'),'w');   
    train_LBP_Matlab_ID = fopen(strcat(fld_feature ,'\train_LBP_Matlab.dat'),'w');
    test_LBP_ID = fopen(strcat(fld_feature ,'\test_LBP.dat'),'w');
    test_LBP_Matlab_ID = fopen(strcat(fld_feature ,'\test_LBP_Matlab.dat'),'w');
    
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
%                     frameRGB = imresize(frameRGB, [256 256]);
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
                    compute_LBP = computeLBPFeatures(frameGray);
                    %test data
                    if(startNum < sub)&&(sub < endNum)
                        fprintf(test_LBP_ID,'%01d', label_Name);
                        fprintf(test_LBP_Matlab_ID,'%01d', label_Name);

                        for k = 1 : length(compute_LBP(1,:))
                            if(compute_LBP(1,k) ~=0)
                                testData = compute_LBP(1 , k);
                                fprintf(test_LBP_ID,' %d:%f', k, testData);
                            end
                            
                            if(compute_LBP(2,k)~=0)
                            testData = compute_LBP(2 , k);
                            fprintf(test_LBP_Matlab_ID,' %d:%f', k, testData);
                            end
                        end
                        fprintf(test_LBP_ID,'\n');
                        fprintf(test_LBP_Matlab_ID,'\n');
                    %train data
                    else
                        fprintf(train_LBP_ID,'%01d', label_Name);
                        fprintf(train_LBP_Matlab_ID,'%01d', label_Name);
                        for k = 1 : length(compute_LBP(1,:))
                            if(compute_LBP(1 , k) ~=0)
                                trainData = compute_LBP(1, k); 
                                fprintf(train_LBP_ID,' %d:%f', k, trainData);
                            end
                            
                            if(compute_LBP(2 , k) ~=0)
                                trainData = compute_LBP(2, k); 
                                fprintf(train_LBP_Matlab_ID,' %d:%f', k, trainData);
                            end
                        end
                        fprintf(train_LBP_ID,'\n');       
                        fprintf(train_LBP_Matlab_ID,'\n'); 
                    end

                end  
            end 
    end
    
    startNum = endNum - 1;
    endNum = startNum + 5;
    
    fclose(train_LBP_ID);
    fclose(train_LBP_Matlab_ID);
    fclose(test_LBP_ID);
    fclose(test_LBP_Matlab_ID);
    fprintf(timeID,'%d:%f\n', times, toc);
    toc
end
fclose(timeID);