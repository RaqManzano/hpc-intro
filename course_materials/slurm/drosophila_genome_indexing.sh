#!/bin/bash
#SBATCH -p training  # name of the partition to run job on
#SBATCH -D /scratch/FIXME/hpc_workshop
#SBATCH -o logs/drosophila_genome_indexing.log
#SBATCH -c 1        # number of CPUs. Default: 1
#SBATCH --mem=1G    # RAM memory. Default: maximum available
#SBATCH -t 00:10:00 # time for the job HH:MM:SS. Default: 1 min

# activate conda environment
source $CONDA_PREFIX/etc/profile.d/conda.sh
FIXME

# make an output directory for the index
mkdir -p results/drosophila/genome

# index the reference genome with bowtie2; the syntax is:
# bowtie2-build input.fa output_prefix
bowtie2-build data/genome/drosophila_genome.fa results/drosophila/genome/index
