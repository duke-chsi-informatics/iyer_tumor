#!/bin/bash
#SBATCH -p chsi
#SBATCH -N 1
#SBATCH -n 40
#SBATCH --mem-per-cpu=8000

WORK_DIR="/work/hy140/iyer_tumor/cellranger_output/scRNA_expect_cells"
HPC_DIR="/hpc/group/chsi/hyang/iyer_tumor/cellranger_output/scRNA_expect_cells"

for result in $WORK_DIR/*
do sample_name="$(basename -- $result)"
   HPC_RESULT_PATH="$HPC_DIR/$sample_name"
   mkdir -p $HPC_RESULT_PATH
   WORK_RESULT_PATH="$result/outs/metrics_summary.csv"
   cp -r $WORK_RESULT_PATH $HPC_RESULT_PATH

done 

#for tcr_dataset in /work/hy140/data/TCR_seq/*
#do dataset_name="$(basename -- $tcr_dataset)" 
#   if [ ! -d "$TCR_DIR/$dataset_name" ];then
#       cp -af $tcr_dataset $TCR_DIR
#   fi
#done    
