function [ img ] = SkinSegmentHSV( img_orig )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
clc
  
   %% 
   %hsv segmentation
   %img_orig=img_org
   img=img_orig; %copy of original image
   hsv=rgb2hsv(img);
   h=hsv(:,:,1);
   s=hsv(:,:,2);
   
   [r c v]=find(h>0.25 | s<=0.15 | s>0.9); %non skin
   numid=size(r,1);
   
   for i=1:numid
       img(r(i),c(i),:)=0;
   end
   
end

