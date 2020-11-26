%% 
clear all; close all; 

deblur_ed_path = '../flownet2-train/models/deblur/test/deblur_ed_results/';
deblur_refinenet_path = '../flownet2-train/models/deblur/test/deblur_refinenet_results/';
label_path = './label_imgs_test/';

fid_psnr = fopen('psnr_compare.list','a+');
fid_ssim = fopen('ssim_compare.list','a+');

num_imgs = 120;
psnr_array = zeros(num_imgs,2);
ssim_array = zeros(num_imgs,2);

for t = 1 : num_imgs
   fileName_ed = strcat(deblur_ed_path,num2str(t),'.jpg');
   img_deblur_ed = imread(fileName_ed);
   fileName_refinenet = strcat(deblur_refinenet_path,num2str(t),'.jpg');
   img_deblur_refinenet = imread(fileName_refinenet);
   fileName_label = strcat(label_path,num2str(t),'.png');
   img_label = imread(fileName_label);
   
   % psnr
   psnr_deblur_ed = psnr(img_deblur_ed,img_label);
   psnr_deblur_ed = roundn(psnr_deblur_ed,-2);
   psnr_deblur_refinenet = psnr(img_deblur_refinenet,img_label);
   psnr_deblur_refinenet = roundn(psnr_deblur_refinenet,-2);

   psnr_array(t,1) = psnr_deblur_ed;  
   psnr_array(t,2) = psnr_deblur_refinenet;
   
   %ssim
   ssim_deblur_ed = ssim(img_deblur_ed,img_label);
   ssim_deblur_ed = roundn(ssim_deblur_ed,-4);
   ssim_deblur_refinenet = ssim(img_deblur_refinenet,img_label);
   ssim_deblur_refinenet = roundn(ssim_deblur_refinenet,-4);

   ssim_array(t,1) = ssim_deblur_ed;  
   ssim_array(t,2) = ssim_deblur_refinenet;
   
   if psnr_deblur_refinenet - psnr_deblur_ed >= -0.2
       temp_line = [num2str(psnr_deblur_ed),' ',num2str(psnr_deblur_refinenet), '\r\n'];
       fprintf( fid_psnr, temp_line );
       temp_line = [num2str(ssim_deblur_ed),' ',num2str(ssim_deblur_refinenet), '\r\n'];
       fprintf( fid_ssim, temp_line );
   end
   
   t
   
end

mean_psnr_deblur_ed = mean(psnr_array(:,1));
mean_psnr_deblur_refinenet = mean(psnr_array(:,2));
mean_ssim_deblur_ed = mean(ssim_array(:,1));
mean_ssim_deblur_refinenet = mean(ssim_array(:,2));

fclose(fid_psnr);
fclose(fid_ssim);



