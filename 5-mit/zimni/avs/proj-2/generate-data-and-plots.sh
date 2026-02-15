#!/bin/bash

SCRIPT_ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ ! -f "grid-scaling-out.csv" ]]; then
    echo "Measuring grid size scaling"
    $SCRIPT_ROOT_PATH/measure-grid-scaling.sh
else
    echo "Grid size scaling results exist. Skipping."
fi

if [[ ! -f "input-scaling-out.csv" ]]; then
    echo "Measuring input size scaling"
    $SCRIPT_ROOT_PATH/measure-input-scaling.sh
else
    echo "Input size scaling results exist. Skipping."
fi

echo "Creating scaling plots"
python3 $SCRIPT_ROOT_PATH/generate-plots.py input-scaling-out.csv $SCRIPT_ROOT_PATH/input-scaling-strong.png input-strong
python3 $SCRIPT_ROOT_PATH/generate-plots.py input-scaling-out.csv $SCRIPT_ROOT_PATH/input-scaling-weak.png input-weak
python3 $SCRIPT_ROOT_PATH/generate-plots.py grid-scaling-out.csv $SCRIPT_ROOT_PATH/grid-scaling.png grid-scaling
