#!/bin/bash
#SBATCH -p chsi
#SBATCH -N 1
#SBATCH -n 40
#SBATCH --mem-per-cpu=8000
wget -P /work/hy140 http://genomics-sg.oss-ap-southeast-1.aliyuncs.com/2020_04/H401SC20030593_2_2020-04-25_221225/H401SC20030593_2.tar
