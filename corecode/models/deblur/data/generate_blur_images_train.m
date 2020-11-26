%% 
clear all; close all; 

h = 256; w = 256;  

blur_path = 'blur_imgs_train/';
label_path = 'label_imgs_train/';
SrcPath =  '/data/xiaoqingyin/DOTA/DOTA_Split/train/images/';  %�洢ͼ���·��
fileExt = '*.png';  %���ȡͼ��ĺ�׺��
%��ȡ����·��
files = dir(fullfile(SrcPath,fileExt));% Sampleath������fileExt��׺��·������
len = size(files,1);

hsize_max = 5;
hsize_interval = 1;
sigma_max = 1;
sigma_interval = 0.1;

len_max = 30;
len_interval = 5; 
theta_max = 360;
theta_interval = 15;

t_interval = 2;
idx_sample = 0;

%����·����ÿһ��ͼ��
for t = 1 : t_interval : len
   fileName = strcat(SrcPath,files(t).name);
   img_src = imread(fileName);
   %imshow(uint8(img_src));
   img_src = imresize(img_src,[h w]);
   
   %% ��˹ģ��
    hsize = hsize_interval *  unidrnd(hsize_max/hsize_interval); 
    sigma = sigma_interval * unidrnd(sigma_max/sigma_interval);
    %fprintf('hsize = %f,,sigma = %f\n',hsize,sigma);
    psf_g = fspecial('gaussian',hsize,sigma); %������������˶��˲���psf
    img_blur_gaussian = imfilter(img_src,psf_g,'replicate','conv');%��psf�����˻�ͼ��
    
%     subplot(1,2,1);
%     imshow(img_src);    
%     subplot(1,2,2); 
%     imshow(img_blur_gaussian);

   %% �˶�ģ��
    len = len_interval *  unidrnd(len_max/len_interval); %�����˶�λ��(����): len_interval*1, len_interval*2, ..., len_interval*(len_max/len_interval)
    theta = theta_interval * (unidrnd(theta_max/theta_interval)-1); %�����˶��Ƕ�: theta_interval*0, theta_interval*1, ..., theta_interval*(theta_max/theta_interval-1),
    %fprintf('len = %d,,theta = %d\n',len,theta);
    psf_m = fspecial('motion',len,theta); %������������˶��˲���psf
    img_blur_gaussian_motion = imfilter(img_blur_gaussian,psf_m,'replicate','conv');%��psf�����˻�ͼ��

%     subplot(1,3,1);
%     imshow(img_src);
%     subplot(1,3,2);
%     imshow(img_blur_gaussian);    
%     subplot(1,3,3); 
%     imshow(img_blur_gaussian_motion);

    idx_sample = idx_sample + 1; 
    imwrite(img_blur_gaussian_motion,[blur_path,num2str(idx_sample),'.png'],'png');
    imwrite(img_src,[label_path,num2str(idx_sample),'.png'],'png');
    
    fprintf('processing sample %d\n',idx_sample);
end




