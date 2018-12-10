#!/bin/bash
#SBATCH -p serial_requeue # Partition to submit to
#SBATCH -J ERUMD2019
#SBATCH -n 1 # Number of cores requested
#SBATCH -N 1 # Ensure that all cores are on one machine
#SBATCH -t 1-15:00 # Runtime in minutes
#SBATCH --mem=100 # Memory per cpu in MB (see also --mem-per-cpu)
#SBATCH --open-mode=append
#SBATCH -e hostname_%j.err # Standard err goes to this filehostname
hostname