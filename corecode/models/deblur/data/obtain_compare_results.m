%% v
clear all; close all; 

deblur_ed_path = '../flownet2-train/models/deblur/test/deblur_ed_results/';
deblur_refinenet_path = '../flownet2-train/models/deblur/test/deblur_refinenet_results/';
blur_path = './blur_imgs_test/';
label_path = './label_imgs_test/';

fid_psnr_compare = fopen('psnr_compare.list');

num_imgs = 400;

inverval_h = 20;
inverval_w = 120;
w = 256;
h = 256;
w_resize = 320;

image_array = ones(4*h+3*inverval_h,w,3)*255;
image_array_out = ones(4*h+3*inverval_h,w_resize,3)*255;

for t = 1 : num_imgs
    
   str = fgetl(fid_psnr_compare);   % read 一行, str是字符串
   index_split = strfind(str,' ');     % return the index of ' '
   psnr_deblur_ed = str2num(str(1:index_split-1));
   psnr_deblur_refinenet = str2num(str(index_split+1:end));
   
   if (psnr_deblur_refinenet - psnr_deblur_ed >= 1.5 )
       fileName_ed = strcat(deblur_ed_path,num2str(t),'.jpg');
       img_deblur_ed = imread(fileName_ed);
       fileName_refinenet = strcat(deblur_refinenet_path,num2str(t),'.jpg');
       img_deblur_refinenet = imread(fileName_refinenet);
       fileName_blur = strcat(blur_path,num2str(t),'.png');
       img_blur = imread(fileName_blur);
       fileName_label = strcat(label_path,num2str(t),'.png');
       img_label = imread(fileName_label);

       image_array(1:h,:,:) = img_label;
       image_array(h+inverval_h+1:h*2+inverval_h,:,:) = img_blur;
       image_array(h*2+inverval_h*2+1:h*3+inverval_h*2,:,:) = img_deblur_ed;
       image_array(h*3+inverval_h*3+1:end,:,:) = img_deblur_refinenet;
   
       image_array_out = imresize(image_array,[4*h+3*inverval_h,w_resize]);
       imwrite(uint8(image_array_out),['compare_results/',num2str(t),'.jpg'],'jpg');
   end
   
end


fclose(fid_psnr_compare);



