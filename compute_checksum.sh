#!/bin/bash
#SBATCH -p chsi
#SBATCH -e slurm.err
#SBATCH -N 1
#SBATCH -n 10
#SBATCH --mem-per-cpu=8000
md5sum /work/hy140/H401SC20030593_2.tar
