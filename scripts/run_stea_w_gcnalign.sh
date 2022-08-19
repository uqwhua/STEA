#!/bin/bash

script_dir=$(dirname "$PWD/${0}")
. $script_dir/_env_settings.sh

# special task settings
export CUDA_VISIBLE_DEVICES="0,1"
tf_device="1"
# sup, semi
initial_training=sup
continue_training=sup
seed=0
max_train_epoch=2000
max_continue_epoch=2000
topK=10
em_iteration_num=10
neural_thr=0
joint_distr_thr=0
no_joint_distr=False
neural_mn=False
joint_distr_mn=True



#for data_name in "zh_en" "ja_en" "fr_en"
for data_name in "zh_en"
do
#  for train_percent in 0.01 0.05 0.1 0.2 0.3
  for train_percent in 0.01
  do
    task="stea_gcnalign_${train_percent}_seed${seed}"

    . $script_dir/_fn_settings.sh

    # task cmds
    if [ ! -d ${data_dir} ]; then
        cp -r ${dataset_root_dir}/original_datasets/${data_name}/ ${data_dir}
    fi


    params="--data_dir=${data_dir} --data_name=${data_name} --train_percent=${train_percent}"
    echo $params
    python ${proj_dir}/stea/run_prepare_data.py ${params}


    params="--data_dir=${data_dir} --data_name=${data_name} --output_dir=${output_dir} --res_dir=${res_dir}
    --topK=${topK} --em_iteration_num=${em_iteration_num} --initial_training=${initial_training} --continue_training=${continue_training}
    --tf_device=${tf_device} --py_exe_fn=${py_exe_full_fn}
    --no_joint_distr=${no_joint_distr}
    --neural_thr=${neural_thr} --joint_distr_thr=${joint_distr_thr} --neural_mn=${neural_mn} --joint_distr_mn=${joint_distr_mn}
    --ea_model=gcnalign"
    echo $params
    python ${proj_dir}/stea/run_stea.py ${params}

    python ${proj_dir}/stea/rm_emb_files.py --out_dir=${output_dir}
  done
done




