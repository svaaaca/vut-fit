#!/bin/bash

#
# @file test.sh
# @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
# @brief Test script for the binary tree top level application.
# @date 2025-05-04
#

# check for the number of arguments
if [ $# -ne 1 ]; then
  exit 1;
fi;

# get the length of the input string
NODE_STRING=$1
NODE_COUNT=${#NODE_STRING}

# check if the number of nodes is greater than zero
if [ $NODE_COUNT -eq 0 ]; then
  exit 2;
fi;

# compilation of the application
mpic++ --prefix /usr/local/share/OpenMPI -o vuv vuv.cpp

# running the application with the number of processes corresponding to the number of nodes
mpirun --oversubscribe --prefix /usr/local/share/OpenMPI -np $NODE_COUNT vuv $NODE_STRING

# cleanup
rm -f vuv
