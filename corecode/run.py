#!/usr/bin/env python2.7

from __future__ import print_function

import time #yxq

import os, sys, numpy as np
import argparse
from scipy import misc

import sys  
sys.path.append('../../python') 
sys.path.append('../../python/caffe')  
import caffe

import tempfile
from math import ceil

# yxq-
#parser = argparse.ArgumentParser()
#parser.add_argument('caffemodel', help='path to model')
#parser.add_argument('deployproto', help='path to deploy prototxt template')
#parser.add_argument('listfile', help='one line should contain paths "img0.ext img1.ext out.flo"')
#parser.add_argument('--gpu',  help='gpu id to use (0, 1, ...)', default=0, type=int)
#parser.add_argument('--verbose',  help='whether to output all caffe logging', action='store_true')

#args = parser.parse_args()

#yxq-
#if(not os.path.exists(args.caffemodel)): raise BaseException('caffemodel does not exist: '+args.caffemodel)
#if(not os.path.exists(args.deployproto)): raise BaseException('deploy-proto does not exist: '+args.deployproto)
#if(not os.path.exists(args.listfile)): raise BaseException('listfile does not exist: '+args.listfile)


#yxq+
path_caffemodel = './model/deblur_refinenet__iter_500000.caffemodel' #deblur_refinenet__iter_500000.caffemodel, deblur__iter_500000.caffemodel
path_deployproto = './model/deploy_refinenet.prototxt' # deploy_refinenet.prototxt,deploy_ed.prototxt
output_folder = './test/deblur_refinenet_results/' #deblur_ed_results, deblur_refinenet_results


if(not os.path.exists(path_caffemodel)): raise BaseException('caffemodel does not exist')
if(not os.path.exists(path_deployproto)): raise BaseException('deploy-proto does not exist')

# yxq-
#def readTupleList(filename):
    #list = []
    #for line in open(filename).readlines():
        #if line.strip() != '':
            #list.append(line.split())

    #return list

#ops = readTupleList(args.listfile)

width = -1
height = -1


#for ent in ops: # yxq:processing each pair: img0,img1
	    
	#print('Processing tuple:', ent) #yxq-
	
	    
img_files = '../../../data/'  + 'test_files.list' #yxq+

        # yxq+
images = []
with open(img_files, 'r') as f: 
     images = [line.strip() for line in f.readlines() if len(line.strip()) > 0]
	
time_total = 0; #yxq

for idx in range(len(images)): # yxq+: processing one image at a time
	    
    # yxq+
    print("Processing image pair %d of %d" % (idx+1, len(images)))
    img_path = images[idx] # yxq: img0 path 

    num_blobs = 1
    input_data = []
    #img0 = misc.imread(ent[0]) # yxq: ent[0]: img0 path #yxq- 
    img = misc.imread(img_path) # yxq+
    if len(img.shape) < 3: input_data.append(img[np.newaxis, np.newaxis, :, :])
    #else:                   input_data.append(img[np.newaxis, :, :, :].transpose(0, 3, 1, 2)[:, [2, 1, 0], :, :]) 
    else:                   input_data.append(img[np.newaxis, :, :, :].transpose(0, 3, 1, 2)[:, :, :, :])
    #yxq:img.transpose(0,3,1,2): convert to number*channels*height*width for caffe
    #img1 = misc.imread(ent[1]) # yxq: ent[1]: img1 path #yxq-

    if width != input_data[0].shape[3] or height != input_data[0].shape[2]:
       width = input_data[0].shape[3]
       height = input_data[0].shape[2]

    vars = {}
    vars['TARGET_WIDTH'] = width
    vars['TARGET_HEIGHT'] = height

    tmp = tempfile.NamedTemporaryFile(mode='w', delete=False)

    proto = open(path_deployproto).readlines() #yxq+		

    for line in proto:
	for key, value in vars.items():
	    tag = "$%s$" % key
            line = line.replace(tag, str(value)) # yxq: replace some content in deploy.proto

	tmp.write(line)

    tmp.flush()

    #if not args.verbose: yxq-
    caffe.set_logging_disabled()
    #caffe.set_device(args.gpu) #yxq-
    caffe.set_device(0)
    caffe.set_mode_gpu()
    #net = caffe.Net(tmp.name, args.caffemodel, caffe.TEST) # yxq: load net #yxq-
    net = caffe.Net(tmp.name, path_caffemodel, caffe.TEST)

    input_dict = {}
    for blob_idx in range(num_blobs):
	input_dict[net.inputs[blob_idx]] = input_data[blob_idx]

    #
    # There is some non-deterministic nan-bug in caffe
    #
    #print('Network forward pass using %s.' % args.caffemodel) #yxq-
    print('Network forward pass using %s.' % path_caffemodel)

        
    start_time = time.clock()
    net.forward(**input_dict) # yxq: calculate the result 
    time_forward = time.clock() - start_time
    time_total = time_total + time_forward

    
    #blob = np.squeeze(net.blobs['conv_last'].data).transpose(1, 2, 0) # yxq: blob: output flow
    blob = np.squeeze(net.blobs['predict_deblur_255'].data).transpose(1, 2, 0) # H, W
 
    #writeFlow(ent[2], blob) #yxq-

    out_path = output_folder + str(idx+1) + '.jpg' # yxq+: replace the output path


    from scipy.misc import imsave
    print('saving image...')
    imsave(out_path,blob)

time_average = time_total / len(images)
print('!!!!time_average: {:.3f}s '.format(time_average))

