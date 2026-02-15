#!/bin/bash

#####################################################
#                                                   #
# @file install.sh                                  #
# @author David Kvaček (xkvace00@stud.fit.vutbr.cz) #
# @brief Installation script for ANFIS project.     #
# @date 2025-12-01                                  #
#                                                   #
#####################################################

echo "-------------------------------"
echo "INSTALLING PROJECT DEPENDENCIES"
echo "-------------------------------"

python3 -m venv venv
source venv/bin/activate
pip install numpy matplotlib

echo "\033[0;32m[OK]\033[0m Installation completed"
