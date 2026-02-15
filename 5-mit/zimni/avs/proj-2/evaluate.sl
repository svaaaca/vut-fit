#!/bin/bash
#SBATCH -p qcpu_exp
#SBATCH -A ATR-25-7
#SBATCH -n 1 
#SBATCH -t 0:45:00
#SBATCH --mail-type END
#SBATCH -J AVS-evaluate

cd $SLURM_SUBMIT_DIR

ml purge 
ml matplotlib/3.5.2-foss-2022a
ml CMake/3.27.6-GCCcore-13.2.0 intel-compilers/2024.2.0 


export OMP_PROC_BIND=close 
export OMP_PLACES=cores


[ -d build-evaluate ] && rm -rf build-evaluate
[ -d build-evaluate ] || mkdir build-evaluate

cd build-evaluate
rm tmp-*

CC=icx CXX=icpx cmake ..
make

bash ../generate-data-and-plots.sh
