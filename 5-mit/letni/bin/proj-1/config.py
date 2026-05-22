#!/usr/bin/env python3

__file__ = "config.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Multi-state Cellular Automaton with Genetic Algorithm configuration."
__date__ = "2026-05-12"

# ---------------------------------------
# --- GENETIC ALGORITHM CONFIGURATION ---
# ---------------------------------------

GENERATIONS = 16
POPULATION_SIZE = 64
ELITE_SIZE = 4
SIMULATION_STEPS = 32
LAST_STEPS = 8
CROSSOVER_RATE = 0.8
MUTATION_RATE = 0.6
STATES = {
    0: (0, 0, 50),
    1: (0, 0, 150),
    2: (0, 50, 200),
    3: (0, 120, 255),
    4: (0, 200, 255),
    5: (0, 255, 200),
    6: (0, 255, 100),
    7: (0, 255, 0),
    8: (150, 255, 0),
    9: (255, 255, 0),
    10: (255, 200, 0),
    11: (255, 150, 0),
    12: (255, 100, 0),
    13: (255, 50, 0),
    14: (200, 0, 0),
    15: (128, 0, 0),
}

# -----------------------------------
# --- VISUALIZATION CONFIGURATION ---
# -----------------------------------

BACKGROUND_COLOR = (40, 40, 40)
DEFAULT_STATE = (128, 128, 128)
FPS = 60
GRID_COLOR = (100, 100, 100)
SPEED = 300
SPEED_MAXIMUM = 1000
SPEED_MINIMUM = 60
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
TILE_SIZE = 20
GRID_WIDTH = WINDOW_WIDTH // TILE_SIZE
GRID_HEIGHT = WINDOW_HEIGHT // TILE_SIZE
