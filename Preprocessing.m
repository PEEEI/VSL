clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear; 
dirfolder = 'words_keyframev2/addition/245/';
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
        
        %% detect region hand
        %image = RegionHand(name);
        image = mul_RegionHand(name);
        new_file = strcat(dir_newname,'/');
        new_file = strcat(strcat(new_file,num2str(i)),'_b.bmp');
        imwrite(image,new_file);
    end
end

