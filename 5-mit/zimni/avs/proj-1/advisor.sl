#!/bin/bash
#SBATCH -p qcpu_exp
#SBATCH -A ATR-25-7
#SBATCH -n 1 
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --comment "use:vtune=2022.2.0"
#SBATCH -t 0:25:00
#SBATCH --mail-type END
#SBATCH -J AVS-advisor
#SBATCH --exclusive             # ensure full node access (avoid interference)

cd $SLURM_SUBMIT_DIR
ml purge
ml VTune Advisor intel-compilers/2024.2.0 CMake/3.23.1-GCCcore-11.3.0

# === Compiler and runtime affinity settings ===
export OMP_PROC_BIND=close
export OMP_PLACES=cores
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export KMP_AFFINITY=compact,1,0

[ -d build-advisor ] && rm -rf build-advisor
[ -d build-advisor ] || mkdir build-advisor
cd build-advisor

CC=icx CXX=icpx cmake -DUSE_O3=OFF ..
make


for calc in "ref" "batch" "line"; do
    rm -rf advisor-$calc
    mkdir advisor-$calc

    # Basic survey
    taskset -c 0 advixe-cl -collect survey -project-dir advisor-$calc  -- ./mandelbrot -c $calc -s 4096

    # Roof line
    taskset -c 0 advixe-cl -collect tripcounts -flop -project-dir advisor-$calc  -- ./mandelbrot -c $calc -s 4096
done



