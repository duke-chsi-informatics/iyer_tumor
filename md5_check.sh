#!/bin/bash
#SBATCH -p chsi
#SBATCH -N 1
#SBATCH -n 24

for datafile in /work/hy140/original_compressed_data/*
do md5sum $datafile
done
