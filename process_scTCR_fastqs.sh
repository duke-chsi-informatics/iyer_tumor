#!/bin/bash
#SBATCH -p chsi
#SBATCH -N 1
#SBATCH -n 84
#SBATCH --mem-per-cpu=8000

WORK_DATA=/work/hy140/data/TCR_seq
WORK_OUTPUT=/work/hy140/iyer_tumor/cellranger_output/TCR

NODE_DATA=/scratch/hy140/iyer_tumor/data/TCR_seq
NODE_OUTPUT=/scratch/hy140/iyer_tumor/cellranger_output/TCR

#############################################################
# This script copies the scTCR seq fastqs from /work on DCC
# to nodes, process them through cellranger pipeline in the
# container image at the nodes, and copies the result back to
# /work. 
#############################################################

mkdir -p $WORK_OUTPUT
mkdir -p $NODE_DATA
mkdir -p $NODE_OUTPUT

# Copy data from /work to /scratch which is local to each node in chsi partition
for dataset in $WORK_DATA/*
do dataset_name="$(basename -- $dataset)"
   if [ ! -d $NODE_DATA/$dataset_name ];then
       cp -ar $dataset $NODE_DATA
   fi
done

# Pull the cellranger container image to the project directory on node
cd /scratch/hy140/iyer_tumor
if [ ! -f /scratch/hy140/iyer_tumor/cellranger.sif ];then
    singularity pull --disable-cache --name cellranger.sif shub://DylanYang7225/Cellranger
fi

# Run the datasets through the cellranger pipelien in the container and copy the results back to /work
cd $NODE_OUTPUT
for dataset in $NODE_DATA/*
do dataset_name="$(basename -- $dataset)"
   if [ ! -d "$NODE_OUTPUT/$dataset_name" ];then
       singularity exec --bind $dataset:/data /scratch/hy140/iyer_tumor/cellranger.sif cellranger vdj --id=$dataset_name --reference=/cellranger/refdata-cellranger-vdj-GRCh38-alts-ensembl-3.1.0 --fastqs=/data
   fi 
done

for result in $NODE_OUTPUT/*
do result_name="$(basename -- $result)"
   if [ ! -d "$WORK_OUTPUT/$result_name" ];then
       cp -ar $result $WORK_OUTPUT
   fi
done

