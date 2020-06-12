#!/bin/bash

#SBATCH -p chsi
#SBATCH -N 1
#SBATCH -n 84
#SBATCH --mem-per-cpu=8000

RNA_DIR="/work/hy140/iyer_tumor/data/RNA_seq"
TCR_DIR="/work/hy140/iyer_tumor/data/TCR_seq"

for rna_dataset in $FILE_DIR/*
do if [ ! -f "$rna_dataset/MD5sum.txt" ];then
       cd $rna_dataset
       touch MD5sum.txt
       md5sum ./* > MD5sum.txt
   fi
done

for tcr_dataset in $TCR_DIR/*
do if [ ! -f "$tcr_dataset/MD5sum.txt" ];then
       cd $tcr_dataset
       touch MD5sum.txt
       md5sum ./* > MD5sum.txt
   fi
done

