#!/usr/bin/env python3

__file__ = "evaluation.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Evaluation module for genome fitness and genetic algorithm metrics plotting."
__date__ = "2026-05-12"

import math
import matplotlib.pyplot as plt
import numpy as np

from automaton import CellularAutomaton
from typing import List, TYPE_CHECKING

if TYPE_CHECKING:
    from ga import GeneticAlgorithmData


def evaluate_genome(genome, simulation_steps: int = None, last_steps: int = None):
    """
    Evaluate a genome by running a cellular automaton simulation and calculating fitness based on Shannon entropy.

    Fitness is based on:
    - the average Shannon entropy of the grid state proportions over the last few steps of the simulation (to focus on equilibrium behavior),
    - a penalty for trivial solutions where one state dominates the grid (e.g., if any state exceeds 95% of the grid, apply a penalty),
    - and a bonus for stability (lower standard deviation of entropy over the last steps indicates more stable behavior).

    Args:
        genome (Genome): The genome to evaluate.
        simulation_steps (int, optional): The total number of steps to run the simulation. Defaults to SIMULATION_STEPS.
        last_steps (int, optional): The number of last steps to consider for calculating the average entropy. Defaults to LAST_STEPS.

    Returns:
        (fitness, metrics) (Tuple[float, dict]): A tuple containing the fitness score and a dictionary of metrics for the given genome.
    """

    from config import SIMULATION_STEPS, LAST_STEPS

    if simulation_steps is None:
        simulation_steps = SIMULATION_STEPS

    if last_steps is None:
        last_steps = LAST_STEPS

    cellular_automaton = CellularAutomaton(genome.states)
    entropies = []
    proportions = []

    # run the simulation for a specified number of steps
    for simulation_step in range(simulation_steps):
        cellular_automaton.step(genome)
        proportions.append(cellular_automaton.get_state_proportions())

        # only calculate entropy for the last N steps to focus on equilibrium behavior
        if simulation_step >= simulation_steps - last_steps:
            entropies.append(cellular_automaton.calculate_entropy())

    # calculate the normalized average entropy (dynamic equilibrium), stability (based on standard deviation of entropy), and penalty for trivial solutions
    entropy = np.mean(entropies) / math.log2(genome.states) if genome.states > 1 else 0.0
    stability = np.exp(-np.std(entropies))
    penalty = 1.0 if np.max(cellular_automaton.get_state_proportions()) > 0.95 else 0.0

    # combine the metrics into a single fitness score, giving more weight to entropy and stability, and penalizing trivial solutions
    fitness = entropy * 0.6 + stability * 0.3 - penalty * 0.1

    metrics = {
        'average_entropy': np.mean(entropies),
        'dynamic_equilibrium': np.mean(entropies) / math.log2(genome.states) if math.log2(genome.states) > 0 else 0.0,
        'entropy_standard_deviation': np.std(entropies),
        'maximum_proportion': np.max(cellular_automaton.get_state_proportions()),
        'penalty': 1.0 if np.max(cellular_automaton.get_state_proportions()) > 0.95 else 0.0,
        'proportions': cellular_automaton.get_state_proportions(),
        'stability': np.exp(-np.std(entropies)),
    }

    return fitness, metrics


def plot_metrics(filename: str = 'metrics.png', experiments: List[List['GeneticAlgorithmData']] = None) -> None:
    """
    Plot the evolution of the genetic algorithm metrics over generations.

    Args:
        filename (str, optional): The output file name. Defaults to 'metrics.png'.
        experiments (List[List[GeneticAlgorithmData]], optional): List of evolution data for experiments, one per configuration.
    """

    if experiments is not None:

        # plot for experiments: 2x2 grid with multiple curves
        fig, axes = plt.subplots(2, 2, figsize=(16, 9), constrained_layout=True)
        axes = axes.flatten()

        for i, evolution in enumerate(experiments):
            if not evolution:
                continue

            generation_numbers = list(range(1, len(evolution) + 1))
            average_entropy = [data.average_entropy for data in evolution]
            average_fitness = [data.average_fitness for data in evolution]
            entropy_standard_deviation = [data.entropy_standard_deviation for data in evolution]
            population_diversity = [data.population_diversity for data in evolution]

            label = f"unique states: {2 ** (i + 1)}"
            axes[0].plot(generation_numbers, average_entropy, marker='o', label=label)
            axes[1].plot(generation_numbers, average_fitness, marker='o', label=label)
            axes[2].plot(generation_numbers, entropy_standard_deviation, marker='o', label=label)
            axes[3].plot(generation_numbers, population_diversity, marker='o', label=label)

        for ax in axes:
            ax.grid(True, linestyle='--', alpha=0.5)
            ax.legend()

        axes[0].set_title('Average Shannon Entropy')
        axes[0].set_xlabel('Generation')
        axes[0].set_ylabel('Shannon Entropy')

        axes[1].set_title('Average Fitness')
        axes[1].set_xlabel('Generation')
        axes[1].set_ylabel('Fitness')

        axes[2].set_title('Standard Deviation of Shannon Entropy')
        axes[2].set_xlabel('Generation')
        axes[2].set_ylabel('Entropy Standard Deviation')

        axes[3].set_title('Population Diversity')
        axes[3].set_xlabel('Generation')
        axes[3].set_ylabel('Genome Distance')

        fig.suptitle('Cellular Automaton Genetic Algorithm Evolution Metrics by Number of Unique States', fontsize=14)
        fig.savefig(filename)
        plt.close(fig)
        print(f"Saving experiment metrics to '{filename}'...\n")
