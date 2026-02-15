#!/bin/bash

#####################################################
#                                                   #
# @file test.sh                                     #
# @author David Kvaček (xkvace00@stud.fit.vutbr.cz) #
# @brief Testing script for learned ANFIS model.    #
# @date 2025-12-01                                  #
#                                                   #
#####################################################

# default values
MODEL="model.json"
SAMPLES=512

# parse options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h | --help)
            echo "usage: ./test.sh [-h | --help] [-m | --model MODEL] [-s | --samples SAMPLES]"
            echo ""
            echo "Testing ANFIS model on a new generated dataset."
            echo ""
            echo "options:"
            echo "  -h | --help             show this help message and exit"
            echo "  -m | --model MODEL      path to the learned model file"
            echo "  -s | --samples SAMPLES  number of test samples to generate"
            exit 0 ;;
        -m | --model) MODEL="$2"; shift ;;
        -s | --samples) SAMPLES="$2"; shift ;;
        *) echo "\033[0;31m[FAIL]\033[0m Unknown option '$1'"; exit 1 ;;
    esac
    shift
done

# checking for model existence
if [ ! -f "$MODEL" ]; then
    echo "\033[0;31m[FAIL]\033[0m Model not found"
    exit 1
fi

echo "---------------------"
echo "RUNNING MODEL TESTING"
echo "---------------------"
echo "Model:   $MODEL"
echo "Samples: $SAMPLES"
echo "---------------------"

# generating new dataset
python3 generator.py $SAMPLES > /dev/null

# running ad-hoc Python script
python3 << END_PYTHON
import numpy as np
import json
from anfis import ANFIS
from main import load_dataset, generate_test

try:
    with open('$MODEL', 'r') as f:
        params = json.load(f)
except Exception as e:
    print(f"\033[0;31m[FAIL]\033[0m {e}")
    exit(1)

x_test, y_test = load_dataset('test.txt')
if x_test is None:
    print(f"\033[0;31m[FAIL]\033[0m Dataset not loaded")
    exit(1)

model = ANFIS(n_inputs=2, n_rules_per_input=2)
model.consequent_params = np.array(params['consequents'])
model.mu = np.array(params['antecedents_mu'])
model.sigma = np.array(params['antecedents_sigma'])
model.antecedent_params = np.hstack((model.mu, model.sigma))
print(f"Testing Samples:  {len(x_test)}")
print(f"Testing Accuracy: {np.mean(model.predict(x_test) == y_test) * 100:.2f} %")
generate_test(model, x_test, y_test)
END_PYTHON

echo "\033[0;32m[OK]\033[0m Testing completed"
