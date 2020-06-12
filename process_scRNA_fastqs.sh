#!/bin/bash
#SBATCH -p chsi
#SBATCH -N 1
#SBATCH -n 84
#SBATCH --mem-per-cpu=8000




#############################################################
# This script copies the scRNA seq fastqs from /work on DCC 
# to nodes, process them through cellranger pipeline in the 
# container image at the nodes, and copies the result back to
# /work.
#############################################################


WORK_DATA=/work/hy140/data/RNA_seq
WORK_OUTPUT_EXP=/work/hy140/iyer_tumor/cellranger_output/expect-cells
WORK_OUTPUT_FOR=/work/hy140/iyer_tumor/cellranger_output/force-cells

NODE_DATA=/scratch/hy140/iyer_tumor/data/RNA_seq
NODE_OUTPUT_EXP=/scratch/hy140/iyer_tumor/cellranger_output/expect-cells
NODE_OUTPUT_FOR=/scratch/hy140/iyer_tumor/cellranger_output/force-cells
mkdir -p $WORK_OUTPUT_EXP
mkdir -p $WORK_OUTPUT_FOR
mkdir -p $NODE_DATA
mkdir -p $NODE_OUTPUT_EXP
mkdir -p $NODE_OUTPUT_FOR


# Copy files from /work to /scratch in node where the data is processed
for dataset in $WORK_DATA/*
do dataset_name="$(basename -- $dataset)"
   if [ ! -d $NODE_DATA/$dataset_name ];then
       cp -ar $dataset $NODE_DATA
       echo "#+++++++++++++++++++++++++++++++++++++++++++++++++++++#"
       echo "Finished copying $dataset_name to node!"
       echo "#+++++++++++++++++++++++++++++++++++++++++++++++++++++#"
   fi
done

# Pull cellranger container image to the project directory
cd /scratch/hy140/iyer_tumor
if [ ! -f /scratch/hy140/iyer_tumor/cellranger.sif ];then
    singularity pull --disable-cache --name cellranger.sif shub://DylanYang7225/Cellranger
fi

#############################################################
# Each dataset is processed twice, with --expect-cells and 
# --force-cells arguments. Three datasets HN295, HN307_Pri
# and HN307_sLN need an extra --sample argument since they
# were split and sequenced in multiple lanes.
#############################################################


# Process datasets with --expect-cells argument and copy results back to /work when finished
cd $NODE_OUTPUT_EXP
TRANSCRIPTOME="--transcriptome=/cellranger/refdata-cellranger-GRCh38-3.0.0"
CELL_ARG="--expect-cells=6000"
CELLRANGER_SIF="/scratch/hy140/iyer_tumor/cellranger.sif"

for dataset in $NODE_DATA/*
do dataset_name="$(basename -- $dataset)"
   if [ ["$dataset_name"=="HN295"] ];then
       singularity exec --bind $dataset:/data $CELLRANGER_SIF cellranger count --id=$dataset_name $TRANSCRIPTOME --sample="HN295-AACGTCAA,HN295-CTGCGATG,HN295-GCATCTCC,HN295-TGTAAGGT" --fastqs=/data $CELL_ARG
   fi

   if [ ["$dataset_name"=="HN307_Pri"] ];then
       singularity exec --bind $dataset:/data $CELLRANGER_SIF cellranger count --id=$dataset_name $TRANSCRIPTOME --sample="HN307_Pri-CACGCCTT,HN307_Pri-GTATATAG,HN307_Pri-TCTCGGGC" --fastqs=/data $CELL_ARG
   fi

   if [ ["$dataset_name"=="HN307_sLN"] ];then
       singularity exec --bind $dataset:/data $CELLRANGER_SIF cellranger count --id=$dataset_name $TRANSCRIPTOME --sample="HN307_sLN-CGTGCAGA,HN307_sLN-GTATGCTC,HN307_sLN-TCGCTTCG" --fastqs=/data $CELL_ARG
   fi
   
   singularity exec --bind $dataset:/data $CELLRANGER_SIF cellranger count --id=$dataset_name $TRANSCRIPTOME --fastqs=/data $CELL_ARG
done

for result in $NODE_OUTPUT_EXP/*
do result_name="$(basename -- $result)"
   if [ ! -d $WORK_OUTPUT_EXP/$result_name ];then
       cp -ar $result $WORK_OUTPUT_EXP
   fi
done

# Process datasets with --force-cells argument and copy the results back to /work when finished
cd $NODE_OUTPUT_FOR
TRANSCRIPTOME="--transcriptome=/cellranger/refdata-cellranger-GRCh38-3.0.0"
CELL_ARG="--force-cells=6000"
CELLRANGER_SIF="/scratch/hy140/iyer_tumor/cellranger.sif"

for dataset in $NODE_DATA/*
do dataset_name="$(basename -- $dataset)"
   if [ ["$dataset_name"=="HN295"] ];then
       singularity exec --bind $dataset:/data $CELLRANGER_SIF cellranger count --id=$dataset_name $TRANSCRIPTOME --sample="HN295-AACGTCAA,HN295-CTGCGATG,HN295-GCATCTCC,HN295-TGTAAGGT" --fastqs=/data $CELL_ARG
   fi

   if [ ["$dataset_name"=="HN307_Pri"] ];then
       singularity exec --bind $dataset:/data $CELLRANGER_SIF cellranger count --id=$dataset_name $TRANSCRIPTOME --sample="HN307_Pri-CACGCCTT,HN307_Pri-GTATATAG,HN307_Pri-TCTCGGGC" --fastqs=/data $CELL_ARG
   fi

   if [ ["$dataset_name"=="HN307_sLN"] ];then
       singularity exec --bind $dataset:/data $CELLRANGER_SIF cellranger count --id=$dataset_name $TRANSCRIPTOME --sample="HN307_sLN-CGTGCAGA,HN307_sLN-GTATGCTC,HN307_sLN-TCGCTTCG" --fastqs=/data $CELL_ARG
   fi

   singularity exec --bind $dataset:/data $CELLRANGER_SIF cellranger count --id=$dataset_name $TRANSCRIPTOME --fastqs=/data $CELL_ARG
done

for result in $NODE_OUTPUT_FOR/*
do result_name="$(basename -- $result)"
   if [ ! -d $WORK_OUTPUT_FOR/$result_name ];then
       cp -ar $result $WORK_OUTPUT_FOR
   fi
done


