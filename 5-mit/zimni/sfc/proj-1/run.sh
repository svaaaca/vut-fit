#!/bin/bash

#####################################################
#                                                   #
# @file run.sh                                      #
# @author David Kvaček (xkvace00@stud.fit.vutbr.cz) #
# @brief Training script for ANFIS model.           #
# @date 2025-12-01                                  #
#                                                   #
#####################################################

# default values
EPOCHS=256
LR=0.08
SAMPLES=512

# parse options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h | --help)
            echo "usage: ./run.sh [-h | --help] [-e | --epochs EPOCHS] [-l | --lr LR] [-s | --samples SAMPLES]"
            echo ""
            echo "Training ANFIS model with specified options."
            echo ""
            echo "options:"
            echo "  -h | --help             show this help message and exit"
            echo "  -e | --epochs EPOCHS    number of training epochs"
            echo "  -l | --lr LR            learning rate"
            echo "  -s | --samples SAMPLES  number of samples to generate"
            exit 0 ;;
        -e | --epochs) EPOCHS="$2"; shift ;;
        -l | --lr) LR="$2"; shift ;;
        -s | --samples) SAMPLES="$2"; shift ;;
        *) echo "\033[0;31m[FAIL]\033[0m Unknown option '$1'"; exit 1 ;;
    esac
    shift
done

# run the main script
python3 main.py $EPOCHS $LR $SAMPLES
