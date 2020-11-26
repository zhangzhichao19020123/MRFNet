% generate FlyingThings3D_release_TRAIN_new.list(based on FlyingThings3D_release_TRAIN.list)

clear all;

fid_train = fopen('deblur_train.list','a+');
fid_test = fopen('deblur_test.list','a+');
num_samples_train = 20000;
num_samples_test = 2000;

%% train list
for i = 1:num_samples_train
 
    path_blur_train = ['blur_imgs_train/',num2str(i),'.png'];
    path_label_train = ['label_imgs_train/',num2str(i),'.png'];
    temp_line = [path_blur_train,' ',path_label_train,'\r\n'];
    
    fprintf( fid_train, temp_line ); 
end

%% test list 
for i = 1:num_samples_test
 
    path_blur_test = ['blur_imgs_test/',num2str(i),'.png'];
    path_label_test = ['label_imgs_test/',num2str(i),'.png'];
    temp_line = [path_blur_test,' ',path_label_test,'\r\n'];
    
    fprintf( fid_test, temp_line ); 
end


fclose(fid_train);
fclose(fid_test);



