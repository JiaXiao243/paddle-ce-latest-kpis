#!/bin/bash

export MKL_NUM_THREADS=1
export OMP_NUM_THREADS=1

cudaid=${gru4rec:=0} # use 0-th card as default
export CUDA_VISIBLE_DEVICES=$cudaid

FLAGS_benchmark=true  python train.py --train_dir train_big_data --vocab_path vocab_big.txt --use_cuda 1 --batch_size 500 --model_dir model_output --pass_num 2 --enable_ce --step_num 1000 >log_1card
cat log_1card | python _ce.py


cudaid=${gru4rec_4:=0,1,2,3} # use 0-th card as default
export CUDA_VISIBLE_DEVICES=$cudaid

FLAGS_benchmark=true  python train.py --train_dir train_big_data --vocab_path vocab_big.txt --use_cuda 1 --parallel 1 --num_devices 2 --batch_size 500 --model_dir model_output --pass_num 2 --enable_ce --step_num 1000 >log_4cards
cat log_4cards | python _ce.py

#infer
python infer.py --test_dir test_data/ --model_dir model_output --start_index 1 --last_index 1 --use_cuda 1 >infer
if [ $? -ne 0 ];then
	echo -e "gru4rec,infer,FAIL"
else
	echo -e "gru4rec,infer,SUCCESS"
fi
