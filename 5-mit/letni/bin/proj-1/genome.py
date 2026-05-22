#!/usr/bin/env python3

__file__ = "genome.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Genome module for multi-state cellular automaton rules and genetic operators."
__date__ = "2026-05-12"

import numpy as np

from config import STATES


class Genome:
    """
    Represents the rules of the cellular automaton as a genome.

    Each genome consists of:
    - weights for each state that determine how much that state contributes to the neighborhood sum,
    - thresholds that determine how the continuous neighborhood sum maps to discrete next states.

    The genome can be mutated (small random changes) and can crossover with another genome to produce offspring.
    """

    def __init__(self: 'Genome', states: int = len(STATES)) -> None:
        """
        Initialize the genome with random weights and thresholds.

        Args:
            states (int, optional): Number of states in the cellular automaton. Defaults to len(STATES).
        """

        self.states = states
        self.thresholds = np.sort(np.random.uniform(-10, 10, states - 1))
        self.weights = np.random.uniform(-2, 2, states)


    def mutate(self: 'Genome', strength: float = 0.2) -> 'Genome':
        """
        Slightly alters the weights and thresholds.

        Args:
            strength (float, optional): The strength of the mutation. Defaults to 0.2.

        Returns:
            self (Genome): The mutated genome.
        """

        self.weights += np.random.normal(0, strength, self.states)
        self.thresholds += np.random.normal(0, strength, self.states - 1)
        self.thresholds = np.sort(self.thresholds)

        return self


    def crossover(self: 'Genome', other: 'Genome') -> 'Genome':
        """
        Create offspring by blending two parent genomes.

        Args:
            other (Genome): The other parent genome.

        Returns:
            child (Genome): The offspring genome.
        """

        # create a new genome and randomly choose weights and thresholds from either parent
        child = Genome(self.states)
        mask = np.random.random(self.states) < 0.5
        child.weights = np.where(mask, self.weights.copy(), other.weights.copy())
        mask = np.random.random(self.states - 1) < 0.5
        child.thresholds = np.where(mask, self.thresholds.copy(), other.thresholds.copy())
        child.thresholds = np.sort(child.thresholds)

        return child


    def copy(self: 'Genome') -> 'Genome':
        """
        Create a deep copy of this genome.

        Args:
            self (Genome): The genome to copy.

        Returns:
            genome (Genome): A copy of the genome.
        """

        genome = Genome(self.states)
        genome.weights = self.weights.copy()
        genome.thresholds = self.thresholds.copy()

        return genome


    def __repr__(self: 'Genome') -> str:
        """
        Return a string representation of the genome's weights and thresholds.

        Args:
            self (Genome): The genome to represent.

        Returns:
            representation (str): A string representation of the genome's weights and thresholds.
        """

        # format the weights and thresholds in a readable way
        representation = f"Genome:\n    - weights = {np.array2string(self.weights, precision=4)},\n    - thresholds = {np.array2string(self.thresholds, precision=4)}"

        return representation
