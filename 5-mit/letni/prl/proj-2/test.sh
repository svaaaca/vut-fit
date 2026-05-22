#!/bin/bash

# @file test.sh
# @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
# @brief Script for running the MPI mesh multiplication algorithm implementation.
# @date 2026-04-13

# check if the required input files exist
if [ ! -f "mat1.txt" ] || [ ! -f "mat2.txt" ]; then
    echo "\033[0;31mERROR:\033[0m Input files 'mat1.txt' and 'mat2.txt' are required for running the algorithm."
    exit 1
fi

# get the dimensions of the input matrices from the first line
m=$(head -n 1 mat1.txt | tr -d '\r' | awk '{print $1}')
k=$(head -n 1 mat2.txt | tr -d '\r' | awk '{print $1}')

# calculate the total number of processes needed for the multiplication
np=$(($m * $k))

# compile the MPI program
mpic++ -O3 -o mm mm.cpp

# run the MPI program with the calculated number of processes
mpirun -np $np ./mm
