#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /scratch/FIXME/hpc_workshop/  # working directory
#SBATCH -o logs/estimate_pi.log  # standard output file
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: 1G
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min

Rscript FIXME
