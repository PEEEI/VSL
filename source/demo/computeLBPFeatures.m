function result = computeLBPFeatures(frameGray)

% % create map for LBP
% mapping = getmapping(8,'u2');

% % crop frame gray and compute LBP overlap 
sizeImg = 256;
i=1;
y_min = 0;
width = sizeImg/4;
height = sizeImg/4;
for y=1:7
    x_min = 0;
    for x=1:7
        I2 = imcrop(frameGray,[x_min y_min width height]);
%         compute_LBP(i,:) = lbp(I2,1,8,mapping,'h');
        compute_LBP_Matlab(i,:) = extractLBPFeatures(I2);
%         imwrite(I2,strcat(num2str(i),'.bmp'));
        x_min = x_min + sizeImg/8;
        i = i + 1;
    end
    y_min = y_min + sizeImg/8;
end

% %features LBP of image input
% result1 = compute_LBP(1,:);
result2 = compute_LBP_Matlab(1,:);
for i=2:49
%     result1 = [result1 compute_LBP(i,:)];
    result2 = [result2 compute_LBP_Matlab(i,:)];    
end

% result(1,:) = result1;
result(1,:) = result2;