#!/usr/bin/env python3

__file__ = "automaton.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Cellular automaton module for grid evolution and entropy metrics."
__date__ = "2026-05-12"

import math
import numpy as np

from config import GRID_WIDTH, GRID_HEIGHT, STATES
from genome import Genome
from scipy.signal import convolve2d


class CellularAutomaton:
    """
    Represents the cellular automaton grid and handles the state updates based on a given genome.

    The automaton uses a Moore neighborhood (8 neighbors) and applies the genome's weights and thresholds to determine the next state of each cell.
    The class also tracks the history of grid states and can calculate the Shannon entropy of the current grid state proportions.
    """

    def __init__(self: 'CellularAutomaton', states: int = len(STATES), width: int = GRID_WIDTH, height: int = GRID_HEIGHT) -> None:
        """
        Initialize the cellular automaton with a random grid.

        Args:
            self (CellularAutomaton): The cellular automaton instance.
            states (int, optional): Number of states in the automaton. Defaults to len(STATES).
            width (int, optional): Width of the grid. Defaults to GRID_WIDTH.
            height (int, optional): Height of the grid. Defaults to GRID_HEIGHT.
        """

        self.entropy = []
        self.grid = np.random.randint(0, states, (height, width))
        self.height = height
        self.history = [self.grid.copy()]
        self.states = states
        self.width = width


    def get_next_grid(self: 'CellularAutomaton', genome: 'Genome') -> np.ndarray:
        """
        Calculate the next grid state based on the genome's rules.

        Args:
            self (CellularAutomaton): The cellular automaton instance.
            genome (Genome): The genome containing the rules for state transitions.

        Returns:
            next (np.ndarray): The next grid state.
        """

        # define a Moore neighborhood kernel (3x3) for convolution
        kernel = np.array([[1, 1, 1], [1, 1, 1], [1, 1, 1]], dtype=float)
        sum = np.zeros_like(self.grid, dtype=float)

        # calculate the weighted sum of neighbors for each state
        for state in range(self.states):

            # wrap around the grid for edge cells and count how many neighbors are in the current state
            contribution = convolve2d((self.grid == state).astype(float), kernel, mode='same', boundary='wrap')
            sum += contribution * genome.weights[state]

        # determine next state based on thresholds
        next = np.zeros_like(self.grid)
        for i in range(self.states - 1):
            next[sum >= genome.thresholds[i]] = i + 1

        return next


    def step(self: 'CellularAutomaton', genome: 'Genome') -> None:
        """
        Advance the automaton by one step.

        Args:
            self (CellularAutomaton): The cellular automaton instance.
            genome (Genome): The genome containing the rules for state transitions.
        """

        # calculate the next grid state and update the history
        self.grid = self.get_next_grid(genome)
        self.history.append(self.grid.copy())


    def calculate_entropy(self: 'CellularAutomaton') -> float:
        """
        Calculate the Shannon entropy of the current grid state proportions.

        Args:
            self (CellularAutomaton): The cellular automaton instance.

        Returns:
            entropy (float): The Shannon entropy of the current grid state proportions.
        """

        cells = self.grid.size
        entropy = 0.0

        # calculate the proportion of each state and sum the entropy contributions
        for state in range(self.states):
            count = np.sum(self.grid == state)
            if count > 0:
                p = count / cells
                entropy -= p * math.log2(p)

        return entropy


    def get_state_proportions(self: 'CellularAutomaton') -> np.ndarray:
        """
        Return the proportion of each state in the current grid.

        Args:
            self (CellularAutomaton): The cellular automaton instance.

        Returns:
            proportions (np.ndarray): The proportion of each state in the current grid.
        """

        cells = self.grid.size
        proportions = np.zeros(self.states)

        # calculate the proportion of each state in the grid
        for state in range(self.states):
            proportions[state] = np.sum(self.grid == state) / cells

        return proportions


    def reset(self: 'CellularAutomaton') -> None:
        """
        Reset the grid to a new random state and clear the history.

        Args:
            self (CellularAutomaton): The cellular automaton instance.
        """

        # reset the grid to a new random state and clear the history
        self.grid = np.random.randint(0, self.states, (self.height, self.width))
        self.history = [self.grid.copy()]
        self.entropy = []
