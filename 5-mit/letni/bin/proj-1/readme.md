# Multi-state Cellular Automaton with Genetic Algorithm

A Python project that evolves cellular automaton rule sets using a genetic algorithm and visualizes the best rule behavior with Pygame.

## Features

- Evolve multi-state cellular automaton genomes
- Evaluate fitness using Shannon entropy and dynamic stability
- Plot evolution metrics over generations
- Run experiments with multiple GA parameter configurations
- Visualize grid evolution and interact with keyboard controls

## Installation

Install dependencies from `requirements.txt`:

```bash
pip install -r requirements.txt
```

**Requirements:**
- Python 3.13+

## Run

```bash
python3 main.py
```

### Options

- `--experiment` : run a parameter sweep experiment
- `--genome <path>` : save best genome metrics to CSV (default `genome.csv`)
- `--hide` : do not launch the Pygame visualization
- `--metrics <path>` : save GA metrics plot to PNG (default `metrics.png`)
- `--runs <n>` : number of runs per experiment configuration
- `--summary <path>` : save experiment summary CSV (default `summary.csv`)

## Controls (visualization mode)

- `SPACE` : toggle run/pause
- `R` : reset grid
- `C` : clear grid
- `N` : single step forward when paused
- `UP/DOWN` : increase/decrease animation speed
