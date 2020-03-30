% 2020-3-29
% This matlab code implements the ERG model for infrared target-background 
% separation.


clc;
clear;
close all;

utilsPath = '../../../utils';
addpath(utilsPath);
addpath('../../../label');
addpath('../../../libs/PROPACK');


for setId = 1
    setImgNumArr = [3 75 75 75 75 5 32 3 1 114 30];
    setImgNum = setImgNumArr(setId);
    clear tarCube;
    tic
    for imgId = 1:4%setImgNum
        img = get_infrared_img(setId, imgId, utilsPath); % double 0-255                                   
        [m, n] = size(img);
        bg=MDTDLMS(img);
        seg=RDLCM(img,bg);
        kth=6;
        th=(kth*max(max(seg))+min(min(seg)))/(kth+1);
        %th=max(max(seg))-1;
        bw=im2bw(uint16(seg),th/65536);
        imwrite(bw,['./result',num2str(setId),'/',num2str(imgId),'.bmp']);
        %figure; imshow(bw,[ ]);
    end % imgId
    toc
    
end % setId