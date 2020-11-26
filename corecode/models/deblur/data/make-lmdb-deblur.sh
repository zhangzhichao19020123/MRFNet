#!/bin/bash

../flownet2-train/build/tools/convert_imageset_deblur.bin deblur_train.list deblur_TRAIN_lmdb 1 lmdb

../flownet2-train/build/tools/convert_imageset_deblur.bin deblur_test.list deblur_TEST_lmdb 1 lmdb

#../../../build/tools/convert_imageset_and_flow.bin src_blur_imgs.list src_blur_imgs_TRAIN_lmdb 0 lmdb

