#!/bin/bash
#
# FreeCell Solver Benchmark Suite
# Runs multiple solver configurations and exports detailed results
# Supports parallel execution for multi-core systems
#

set -e

# Configuration
BINARY="./fc-sui"
RESULTS_DIR="benchmark_results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="${RESULTS_DIR}/benchmark_${TIMESTAMP}.csv"
SUMMARY_FILE="${RESULTS_DIR}/benchmark_${TIMESTAMP}_summary.txt"
TEMP_DIR="${RESULTS_DIR}/temp_${TIMESTAMP}"

# Parallel execution settings
PARALLEL_JOBS=${PARALLEL_JOBS:-36}  # Default to 36 parallel jobs, can override with env var

# Create results and temp directories
mkdir -p "${RESULTS_DIR}"
mkdir -p "${TEMP_DIR}"

# CSV Header
echo "timestamp,solver,deals,seed,easy_mode,mem_limit,run,solved,total,solve_rate,avg_solution_length,avg_time_us,total_states_expanded,real_time_sec,user_time_sec,sys_time_sec,peak_memory_kb,mem_abort" > "${RESULTS_FILE}"

# Function to run a benchmark and extract results
run_benchmark() {
    local solver=$1
    local deals=$2
    local seed=$3
    local easy_mode=$4
    local mem_limit=$5
    local run_num=$6
    local heuristic=${7:-"nb_not_home"}  # Optional heuristic for A*
    local dls_limit=${8:-1000000}        # Optional DLS limit for DFS
    
    # Create unique output file for this run
    local run_id="${solver}_${deals}_${seed}_${easy_mode}_${run_num}"
    local temp_output="${TEMP_DIR}/${run_id}.out"
    local temp_time="${TEMP_DIR}/${run_id}.time"
    local temp_csv="${TEMP_DIR}/${run_id}.csv"
    
    # Build command
    local cmd="${BINARY} ${deals} ${seed} --solver ${solver}"
    
    if [ "${easy_mode}" != "none" ]; then
        cmd="${cmd} --easy-mode ${easy_mode}"
    fi
    
    if [ "${mem_limit}" != "default" ]; then
        cmd="${cmd} --mem-limit ${mem_limit}"
    fi
    
    if [ "${solver}" = "a_star" ]; then
        cmd="${cmd} --heuristic ${heuristic}"
    fi
    
    if [ "${solver}" = "dfs" ]; then
        cmd="${cmd} --dls-limit ${dls_limit}"
    fi
    
    # Run with time measurement and capture output
    # %M = Maximum resident set size (peak memory in KB)
    # Detect OS
    if [ "$(uname)" = "Darwin" ]; then
        # BSD time (macOS) – output formatting must be parsed manually
        /usr/bin/time -l ${cmd} > "${temp_output}" 2> "${temp_time}" || true

        # Extract timing and memory
        real_time_sec=$(grep "real" "${temp_time}" | awk '{print $1}')
        user_time_sec=$(grep "user" "${temp_time}" | awk '{print $1}')
        sys_time_sec=$(grep "sys" "${temp_time}" | awk '{print $1}')
        peak_memory_kb=$(grep "maximum resident set size" "${temp_time}" | awk '{print $1}')

        # Convert real/user/sys to seconds (BSD already prints seconds)
        # peak_memory_kb is already in KB (BSD prints bytes → divide by 1024)
        peak_memory_kb=$(( peak_memory_kb / 1024 ))

    else
        # GNU time (Linux)
        /usr/bin/time -f "TIMING: %e %U %S %M" ${cmd} > "${temp_output}" 2> "${temp_time}" || true

        timing_line=$(grep "TIMING:" "${temp_time}" 2>/dev/null || echo "TIMING: 0 0 0 0")
        real_time_sec=$(echo "${timing_line}" | awk '{print $2}')
        user_time_sec=$(echo "${timing_line}" | awk '{print $3}')
        sys_time_sec=$(echo "${timing_line}" | awk '{print $4}')
        peak_memory_kb=$(echo "${timing_line}" | awk '{print $5}')
    fi
    
    # Extract metrics from output
    local solved=$(grep -oP 'Solved \K\d+(?= /)' "${temp_output}" 2>/dev/null || echo "0")
    local total=$(grep -oP 'Solved \d+ / \K\d+' "${temp_output}" 2>/dev/null || echo "0")
    local solve_rate=$(grep -oP 'Solved \d+ / \d+ \[ \K[\d.]+' "${temp_output}" 2>/dev/null || echo "0")
    local avg_solution=$(grep -oP 'Avg solution length \K[\d.]+' "${temp_output}" 2>/dev/null || echo "NA")
    local avg_time=$(grep -oP 'Avg time taken: \K\d+' "${temp_output}" 2>/dev/null || echo "0")
    local states_expanded=$(grep -oP 'Total #states expaned: \K\d+' "${temp_output}" 2>/dev/null || echo "0")
    
    # Check if memory limit was exceeded and caused abort
    local mem_abort="no"
    if grep -q "MEM: Already taken.*over the limit.*Aborting" "${temp_output}" 2>/dev/null; then
        mem_abort="yes"
    fi
    # Also check stderr (time file) where the message might be
    if grep -q "MEM: Already taken.*over the limit.*Aborting" "${temp_time}" 2>/dev/null; then
        mem_abort="yes"
    fi
    
    # Extract timing and memory from time command output
    local timing_line=$(grep "TIMING:" "${temp_time}" 2>/dev/null || echo "TIMING: 0 0 0 0")
    local real_time_sec=$(echo "${timing_line}" | awk '{print $2}')
    local user_time_sec=$(echo "${timing_line}" | awk '{print $3}')
    local sys_time_sec=$(echo "${timing_line}" | awk '{print $4}')
    local peak_memory_kb=$(echo "${timing_line}" | awk '{print $5}')
    
    # Write to temp CSV file (will be merged later)
    echo "${TIMESTAMP},${solver},${deals},${seed},${easy_mode},${mem_limit},${run_num},${solved},${total},${solve_rate},${avg_solution},${avg_time},${states_expanded},${real_time_sec},${user_time_sec},${sys_time_sec},${peak_memory_kb},${mem_abort}" > "${temp_csv}"
    
    # Save command and output for detailed report
    local temp_detail="${TEMP_DIR}/${run_id}.detail"
    echo "COMMAND: ${cmd}" > "${temp_detail}"
    echo "---" >> "${temp_detail}"
    
    # Append stdout
    if [ -f "${temp_output}" ] && [ -s "${temp_output}" ]; then
        cat "${temp_output}" >> "${temp_detail}"
    fi
    
    # Append stderr (contains memory abort messages), but exclude TIMING line
    if [ -f "${temp_time}" ] && [ -s "${temp_time}" ]; then
        grep -v "^TIMING:" "${temp_time}" >> "${temp_detail}" 2>/dev/null || true
    fi
    
    # Clean up temp output files
    rm -f "${temp_output}" "${temp_time}"
}

# Print banner
echo "========================================"
echo "FreeCell Solver Benchmark Suite"
echo "Started at: $(date)"
echo "Parallel jobs: ${PARALLEL_JOBS}"
echo "Results will be saved to: ${RESULTS_FILE}"
echo "========================================"
echo ""

# Build list of all benchmark jobs
JOB_LIST="${TEMP_DIR}/job_list.txt"
> "${JOB_LIST}"  # Clear file

# BFS Benchmarks - Test scalability and memory efficiency
echo "=== Queuing BFS Benchmarks ==="
# Very easy - should solve 100%
echo "bfs 100 42 1 default 1 nb_not_home 1000000" >> "${JOB_LIST}"
# Easy - high solve rate
echo "bfs 50 42 5 default 2 nb_not_home 1000000" >> "${JOB_LIST}"
echo "bfs 50 100 5 default 3 nb_not_home 1000000" >> "${JOB_LIST}"
# Medium - good solve rate, reasonable time
echo "bfs 30 42 10 default 4 nb_not_home 1000000" >> "${JOB_LIST}"
echo "bfs 30 100 15 default 5 nb_not_home 1000000" >> "${JOB_LIST}"
echo "bfs 30 200 20 default 6 nb_not_home 1000000" >> "${JOB_LIST}"
# Hard - lower solve rate, tests limits
echo "bfs 20 42 30 default 7 nb_not_home 1000000" >> "${JOB_LIST}"
echo "bfs 20 100 40 default 8 nb_not_home 1000000" >> "${JOB_LIST}"
# Very hard - may not solve all, tests memory limits
echo "bfs 10 42 50 default 9 nb_not_home 1000000" >> "${JOB_LIST}"
echo "bfs 10 100 none default 10 nb_not_home 1000000" >> "${JOB_LIST}"
# Speed test - many easy problems
echo "bfs 200 42 1 default 11 nb_not_home 1000000" >> "${JOB_LIST}"

# DFS Benchmarks - Test depth limits and different strategies
echo "=== Queuing DFS Benchmarks ==="
# Test different depth limits on easy problems
echo "dfs 50 42 1 default 12 nb_not_home 50000" >> "${JOB_LIST}"     # Shallow
echo "dfs 50 42 1 default 13 nb_not_home 100000" >> "${JOB_LIST}"    # Medium shallow
echo "dfs 50 42 1 default 14 nb_not_home 200000" >> "${JOB_LIST}"    # Medium
echo "dfs 50 42 1 default 15 nb_not_home 500000" >> "${JOB_LIST}"    # Deep
echo "dfs 50 42 1 default 16 nb_not_home 1000000" >> "${JOB_LIST}"   # Very deep
# Test on medium difficulty
echo "dfs 30 100 10 default 17 nb_not_home 100000" >> "${JOB_LIST}"
echo "dfs 30 100 10 default 18 nb_not_home 500000" >> "${JOB_LIST}"
echo "dfs 30 100 20 default 19 nb_not_home 1000000" >> "${JOB_LIST}"
# Test on harder problems
echo "dfs 20 100 30 default 20 nb_not_home 500000" >> "${JOB_LIST}"
echo "dfs 10 100 40 default 21 nb_not_home 1000000" >> "${JOB_LIST}"

# A* Benchmarks - Test memory management and heuristic effectiveness
echo "=== Queuing A* Benchmarks ==="
# Very easy - should solve quickly with minimal memory
echo "a_star 50 42 1 500000000 22 nb_not_home 1000000" >> "${JOB_LIST}"      # 500MB limit
echo "a_star 50 42 5 1000000000 23 nb_not_home 1000000" >> "${JOB_LIST}"     # 1GB limit
# Easy-medium - test scaling
echo "a_star 30 42 5 1000000000 24 nb_not_home 1000000" >> "${JOB_LIST}"
echo "a_star 30 100 10 1500000000 25 nb_not_home 1000000" >> "${JOB_LIST}"   # 1.5GB limit
echo "a_star 30 200 15 2000000000 26 nb_not_home 1000000" >> "${JOB_LIST}"   # 2GB limit
# Medium - should use significant memory
echo "a_star 20 42 10 2000000000 27 nb_not_home 1000000" >> "${JOB_LIST}"
echo "a_star 20 100 20 2000000000 28 nb_not_home 1000000" >> "${JOB_LIST}"
echo "a_star 20 200 30 3000000000 29 nb_not_home 1000000" >> "${JOB_LIST}"   # 3GB limit
# Hard - test memory limits
echo "a_star 10 42 30 3000000000 30 nb_not_home 1000000" >> "${JOB_LIST}"
echo "a_star 10 100 40 4000000000 31 nb_not_home 1000000" >> "${JOB_LIST}"   # 4GB limit
echo "a_star 10 200 50 4000000000 32 nb_not_home 1000000" >> "${JOB_LIST}"
# Very hard - may hit memory limits
echo "a_star 5 100 none 4000000000 33 nb_not_home 1000000" >> "${JOB_LIST}"
echo "a_star 5 200 none 5000000000 34 nb_not_home 1000000" >> "${JOB_LIST}"  # 5GB limit

# Memory limit stress tests - how do solvers handle memory constraints?
echo "=== Queuing Memory Constraint Tests ==="
# BFS with limited memory
echo "bfs 30 42 10 500000000 35 nb_not_home 1000000" >> "${JOB_LIST}"        # 500MB
echo "bfs 30 42 10 1000000000 36 nb_not_home 1000000" >> "${JOB_LIST}"       # 1GB
echo "bfs 30 42 10 2000000000 37 nb_not_home 1000000" >> "${JOB_LIST}"       # 2GB
# A* with different memory limits on same problem
echo "a_star 20 100 20 500000000 38 nb_not_home 1000000" >> "${JOB_LIST}"    # 500MB
echo "a_star 20 100 20 1000000000 39 nb_not_home 1000000" >> "${JOB_LIST}"   # 1GB
echo "a_star 20 100 20 2000000000 40 nb_not_home 1000000" >> "${JOB_LIST}"   # 2GB
echo "a_star 20 100 20 4000000000 41 nb_not_home 1000000" >> "${JOB_LIST}"   # 4GB

# Seed variation - test consistency and variance
echo "=== Queuing Seed Variation Tests ==="
# BFS with different seeds on medium difficulty
run_counter=42
for seed in 42 100 200 500 1000 2000; do
    echo "bfs 30 ${seed} 15 default ${run_counter} nb_not_home 1000000" >> "${JOB_LIST}"
    run_counter=$((run_counter + 1))
done
# A* with different seeds
for seed in 42 100 200 500; do
    echo "a_star 20 ${seed} 20 2000000000 ${run_counter} nb_not_home 1000000" >> "${JOB_LIST}"
    run_counter=$((run_counter + 1))
done

# Problem count scaling - speed vs accuracy tradeoff
echo "=== Queuing Problem Count Scaling Tests ==="
# Many easy problems - throughput test
echo "bfs 500 42 1 default 52 nb_not_home 1000000" >> "${JOB_LIST}"
echo "dfs 500 42 1 default 53 nb_not_home 200000" >> "${JOB_LIST}"
echo "a_star 100 42 5 1000000000 54 nb_not_home 1000000" >> "${JOB_LIST}"
# Fewer hard problems - quality test  
echo "bfs 5 100 none default 55 nb_not_home 1000000" >> "${JOB_LIST}"
echo "a_star 3 200 none 5000000000 56 nb_not_home 1000000" >> "${JOB_LIST}"

# Easy-mode progression - understand difficulty scaling
echo "=== Queuing Easy-Mode Progression Tests ==="
run_counter=57
for easy in 1 5 10 20 30 40 50; do
    echo "bfs 20 100 ${easy} default ${run_counter} nb_not_home 1000000" >> "${JOB_LIST}"
    run_counter=$((run_counter + 1))
done

# Memory heavy tests
echo "=== Queuing Memory-Heavy Tests ==="
echo "a_star 1 599 none default 64 nb_not_home 1000000" >> "${JOB_LIST}"
echo "dfs 1 599 100 default 65 nb_not_home 1000000" >> "${JOB_LIST}"

# Count total jobs
TOTAL_JOBS=$(wc -l < "${JOB_LIST}")
echo ""
echo "Total benchmark jobs queued: ${TOTAL_JOBS}"
echo "Running with ${PARALLEL_JOBS} parallel workers..."
echo ""

# Export function for parallel execution
export -f run_benchmark
export BINARY TIMESTAMP TEMP_DIR

# Run benchmarks in parallel using xargs
echo "Starting parallel execution..."
cat "${JOB_LIST}" | xargs -P "${PARALLEL_JOBS}" -I {} bash -c 'run_benchmark {}'

# Merge all CSV results
echo ""
echo "Merging results..."
echo "timestamp,solver,deals,seed,easy_mode,mem_limit,run,solved,total,solve_rate,avg_solution_length,avg_time_us,total_states_expanded,real_time_sec,user_time_sec,sys_time_sec,peak_memory_kb,mem_abort" > "${RESULTS_FILE}"
cat "${TEMP_DIR}"/*.csv >> "${RESULTS_FILE}" 2>/dev/null || true

# Generate summary report
echo ""
echo "Generating summary report..."

cat > "${SUMMARY_FILE}" << EOF
FreeCell Solver Benchmark Summary
Generated: $(date)
Timestamp: ${TIMESTAMP}

=== Configuration ===
Binary: ${BINARY}
Results CSV: ${RESULTS_FILE}

=== Benchmark Results ===

EOF

# Aggregate statistics by solver type
for solver in bfs dfs a_star; do
    echo "=== ${solver} Summary ===" >> "${SUMMARY_FILE}"
    
    # Extract data for this solver (excluding memory aborts and invalid runs)
    grep "^${TIMESTAMP},${solver}," "${RESULTS_FILE}" | grep -v ",yes$" | awk -F',' '
    BEGIN {
        total_runs = 0
        total_solved = 0
        total_problems = 0
        sum_time = 0
        sum_states = 0
        valid_time_runs = 0
    }
    {
        # Only count runs with total > 0 (actual problems attempted)
        if ($9 > 0) {
            total_runs++
            total_solved += $8
            total_problems += $9
            sum_states += $13
            
            # Only include runs with valid runtime (> 0) in time average
            if ($14 > 0) {
                sum_time += $14
                valid_time_runs++
            }
        }
    }
    END {
        if (total_runs > 0) {
            avg_solve_rate = (total_problems > 0) ? (total_solved * 100.0 / total_problems) : 0
            avg_time = (valid_time_runs > 0) ? (sum_time / valid_time_runs) : 0
            avg_states = sum_states / total_runs
            printf("Total runs: %d\n", total_runs)
            printf("Problems solved: %d / %d (%.2f%%)\n", total_solved, total_problems, avg_solve_rate)
            printf("Average runtime: %.3f seconds\n", avg_time)
            printf("Average states expanded: %.0f\n", avg_states)
        } else {
            printf("No successful runs (all aborted due to memory limits)\n")
        }
    }
    ' >> "${SUMMARY_FILE}"
    echo "" >> "${SUMMARY_FILE}"
done

# Memory abort statistics
echo "=== Memory Limit Aborts ===" >> "${SUMMARY_FILE}"
grep ",yes$" "${RESULTS_FILE}" 2>/dev/null | awk -F',' '{printf("%s: %s deals, seed %s, easy_mode %s, mem_limit %s\n", $2, $3, $4, $5, $6)}' >> "${SUMMARY_FILE}" || echo "No memory limit aborts detected" >> "${SUMMARY_FILE}"
echo "" >> "${SUMMARY_FILE}"

# Best and worst runs
echo "=== Best Runs (by solve rate) ===" >> "${SUMMARY_FILE}"
tail -n +2 "${RESULTS_FILE}" | grep -v ",yes$" | awk -F',' '$9 > 0' | sort -t',' -k10 -rn | head -5 | awk -F',' '{printf("%s: %s/%s solved (%.1f%%), %.2fs\n", $2, $8, $9, $10, $14)}' >> "${SUMMARY_FILE}"
echo "" >> "${SUMMARY_FILE}"

echo "=== Fastest Runs (by runtime) ===" >> "${SUMMARY_FILE}"
tail -n +2 "${RESULTS_FILE}" | grep -v ",yes$" | awk -F',' '$9 > 0 && $14 > 0' | sort -t',' -k14 -n | head -5 | awk -F',' '{printf("%s %s deals (seed %s): %.2fs, %s/%s solved\n", $2, $3, $4, $14, $8, $9)}' >> "${SUMMARY_FILE}"
echo "" >> "${SUMMARY_FILE}"

echo "=== Slowest Runs (by runtime) ===" >> "${SUMMARY_FILE}"
tail -n +2 "${RESULTS_FILE}" | grep -v ",yes$" | awk -F',' '$9 > 0 && $14 > 0' | sort -t',' -k14 -rn | head -5 | awk -F',' '{printf("%s %s deals (seed %s): %.2fs, %s/%s solved\n", $2, $3, $4, $14, $8, $9)}' >> "${SUMMARY_FILE}"
echo "" >> "${SUMMARY_FILE}"

# Detailed output for all runs
echo "=== Detailed Output for All Runs ===" >> "${SUMMARY_FILE}"
echo "" >> "${SUMMARY_FILE}"

# Sort detail files by solver, then by parameters for organized output
for detail_file in $(ls "${TEMP_DIR}"/*.detail 2>/dev/null | sort); do
    echo "========================================" >> "${SUMMARY_FILE}"
    cat "${detail_file}" >> "${SUMMARY_FILE}"
    echo "" >> "${SUMMARY_FILE}"
done

if [ ! -f "${TEMP_DIR}"/*.detail 2>/dev/null ]; then
    echo "No detailed output files found" >> "${SUMMARY_FILE}"
fi
echo "" >> "${SUMMARY_FILE}"

# Print summary to console
cat "${SUMMARY_FILE}"

# Clean up temp directory
echo ""
echo "Cleaning up temporary files..."
rm -rf "${TEMP_DIR}"

echo ""
echo "========================================"
echo "Benchmark Complete!"
echo "Finished at: $(date)"
echo "Results saved to:"
echo "  CSV: ${RESULTS_FILE}"
echo "  Summary: ${SUMMARY_FILE}"
echo "========================================"
