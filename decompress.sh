#!/bin/bash
#SBATCH -p chsi
#SBATCH -N 1
#SBATCH -n 84
#SBATCH --mem-per-cpu 8000
#SBATCH -o decompress_H401SC20030593_2.out
tar -xvf /work/hy140/iyer_tumor/original_compressed_data/H401SC20030593_2.tar -C /work/hy140/iyer_tumor/data
echo 'succesfully decompressed'


