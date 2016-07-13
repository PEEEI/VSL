function result = extractLPQFeatures(frameGray)
% % crop frame gray and compute LBP overlap 
sizeImg = 256;
i=1;
y_min = 0;
width = sizeImg/4;
height = sizeImg/4;
length = 5;
for y=1:length
    x_min = 0;
    for x=1:length
        I2 = imcrop(frameGray,[x_min y_min width height]);
%         imwrite(I2,strcat(num2str(i),'.bmp'));
        
        computeLPQ(i,:) = lpq(I2);     
        x_min = x_min + (width/4)*3;
        i = i + 1;
    end
    y_min = y_min + (height/4)*3;
end

% %features LBP of image input
result = computeLPQ(1,:);
for i=2:length*length
    result = [result computeLPQ(i,:)];    
end