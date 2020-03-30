% 2017-03-25
% This matlab code implements the NIPPS model for infrared target-background 
% separation.

% Yimian Dai. Questions? yimian.dai@gmail.com
% Copyright: College of Electronic and Information Engineering, 
%            Nanjing University of Aeronautics and Astronautics

clc;
clear;
close all;

utilsPath = '../../../utils';
addpath(utilsPath);
addpath('../../../label');
addpath('../../../libs/PROPACK');

% setup parameters
patchSize = 50;
slideStep = 10;
lambdaL = 2;
ratioN  = 0.005;

for setId = 1
    setImgNumArr = [3 75 75 75 75 5 32 3 1 114 30];
    setImgNum = setImgNumArr(setId);
    clear tarCube;
    tic;
    for imgId = 1:4%1:setImgNum
        img = get_infrared_img(setId, imgId, utilsPath); % double 0-255                                
                
        D = gen_patch_img(img, patchSize, slideStep);        
        [m, n] = size(D);
        lambda = lambdaL / sqrt(min(m, n));        
        [hatA, hatE, ~] = nipps(D, lambda, ratioN);                    
        tarImg = res_patch_img_mean(hatE, img, patchSize, slideStep);
        imwrite(tarImg,['./result',num2str(setId),'/',num2str(imgId),'.bmp']);
        %figure; imshow(tarImg, []);
    end % imgId
    toc
end % setId