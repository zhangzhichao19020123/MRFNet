% generate FlyingThings3D_release_TRAIN_new.list(based on FlyingThings3D_release_TRAIN.list)

clear all;

fid_test = fopen('test_files.list','a+');
num_samples_test = 2000;

%% test list 
for i = 1:num_samples_test

    temp_line = ['../../../data/blur_imgs_test/',num2str(i),'.png','\r\n'];
    
    fprintf( fid_test, temp_line );
    
end

fclose(fid_test);



