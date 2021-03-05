#!/bin/bash
#SBATCH -J vasp4fun
#SBATCH -N 1
#SBATCH --ntasks-per-node=48
#SBATCH --threads-per-core=1
#SBATCH --ntasks-per-core=1
#SBATCH --partition=mem_0384


export PSI_SCRATCH=/gpfs/data/fs71337/airmler/temp
/home/fs71337/airmler/src/psi4new/build/stage/usr/local/psi4/bin/psi4 -i input.dat -n 48
