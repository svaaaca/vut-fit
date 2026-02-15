#!/bin/bash

#####################################################
#                                                   #
# @file clean.sh                                    #
# @author David Kvaček (xkvace00@stud.fit.vutbr.cz) #
# @brief Cleaning script for ANFIS project.         #
# @date 2025-12-01                                  #
#                                                   #
#####################################################

echo "--------------------------"
echo "CLEANING PROJECT DIRECTORY"
echo "--------------------------"

rm -r __pycache__ 2> /dev/null
echo "Removing __pycache__/"

rm -f model.json 2> /dev/null
echo "Removing model.json"

rm -f mse.png test.png 2> /dev/null
echo "Removing mse.png, test.png"

rm -f test.txt train.txt 2> /dev/null
echo "Removing test.txt, train.txt"

echo "--------------------------"
echo "\033[0;32m[OK]\033[0m Cleaning completed"
