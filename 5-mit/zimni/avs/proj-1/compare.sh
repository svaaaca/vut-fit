SCRIPT_ROOT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CALCULATORS=("ref" "line" "batch")

for calc in "${CALCULATORS[@]}"; do
    ./mandelbrot -s 512 -i 100 -c $calc --batch cmp_$calc.npz
done

VALID=1
echo "Reference vs line"
python3 ${SCRIPT_ROOT_PATH}/compare.py cmp-ref.npz cmp-line.npz  || VALID=0

echo "Reference vs batch"
python3 ${SCRIPT_ROOT_PATH}/compare.py cmp-ref.npz cmp-batch.npz || VALID=0

echo "Batch vs line"
python3 ${SCRIPT_ROOT_PATH}/compare.py cmp-batch.npz cmp-line.npz || VALID=0

if [ "$VALID" -eq 1 ]; then
    echo "Test passed";
else
    echo "Test failed";
    exit 1
fi
