#!/usr/bin/env python3

__file__ = "experiments.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Experiment module for configuration generation and result summarization."
__date__ = "2026-05-12"

import csv
import numpy as np

from config import STATES, CROSSOVER_RATE, ELITE_SIZE, GENERATIONS, GRID_HEIGHT, GRID_WIDTH, LAST_STEPS, MUTATION_RATE, POPULATION_SIZE, SIMULATION_STEPS
from ga import ExperimentData, GeneticAlgorithm, GeneticAlgorithmData
from typing import Dict, List


def create_experiments() -> List[Dict[str, object]]:
    """
    Create a list of configurations for running experiments with different numbers of states.

    Returns:
        experiments (List[Dict[str, object]]): A list of configuration dictionaries.
    """

    experiments = []
    for states in [2, 4, 8, 16]:
        experiments.append({
            'states': states,
            'generations': GENERATIONS,
            'population_size': POPULATION_SIZE,
            'elite_size': ELITE_SIZE,
            'simulation_steps': SIMULATION_STEPS,
            'last_steps': LAST_STEPS,
            'crossover_rate': CROSSOVER_RATE,
            'mutation_rate': MUTATION_RATE,
        })

    return experiments


def run_configuration(configuration: Dict[str, object], runs: int = 1) -> tuple[ExperimentData, List[List[GeneticAlgorithmData]]]:
    """
    Run a single configuration of the genetic algorithm for a specified number of runs and return summary metrics and evolution data.

    Args:
        configuration (Dict[str, object]): A dictionary containing the parameters for the genetic algorithm configuration to run.
        runs (int, optional): The number of runs to perform for this configuration. Defaults to 1.

    Returns:
        (summary, evolutions) (Tuple[ExperimentData, List[List[GeneticAlgorithmData]]]): An ExperimentData object containing the summary metrics and a list of evolution data for each run.
    """

    average_entropies = []
    average_fitnesses = []
    entropy_standard_deviations = []
    fitness_standard_deviations = []
    maximum_entropies = []
    maximum_fitnesses = []
    minimum_entropies = []
    minimum_fitnesses = []
    population_diversities = []
    evolutions = []

    # run the genetic algorithm for the specified number of runs and collect metrics for each run
    for _ in range(runs):
        genetic_algorithm = GeneticAlgorithm(float(configuration.get('crossover_rate', CROSSOVER_RATE)), int(configuration.get('elite_size', ELITE_SIZE)), int(configuration.get('last_steps', LAST_STEPS)), float(configuration.get('mutation_rate', MUTATION_RATE)), int(configuration.get('population_size', POPULATION_SIZE)), int(configuration.get('simulation_steps', SIMULATION_STEPS)), int(configuration.get('states', len(STATES))))
        evolution = genetic_algorithm.evolve(int(configuration.get('generations', GENERATIONS)))
        evolutions.append(evolution)
        average_entropies.append(evolution[-1].average_entropy)
        average_fitnesses.append(evolution[-1].average_fitness)
        entropy_standard_deviations.append(evolution[-1].entropy_standard_deviation)
        fitness_standard_deviations.append(evolution[-1].fitness_standard_deviation)
        maximum_entropies.append(evolution[-1].maximum_entropy)
        maximum_fitnesses.append(evolution[-1].maximum_fitness)
        minimum_entropies.append(evolution[-1].minimum_entropy)
        minimum_fitnesses.append(evolution[-1].minimum_fitness)
        population_diversities.append(evolution[-1].population_diversity)
        print("=" * 80 + "\n")

    # calculate the average metrics across all runs for this configuration and return them in an ExperimentData object
    summary = ExperimentData(float(np.mean(average_entropies)), float(np.mean(average_fitnesses)), configuration, float(np.mean(entropy_standard_deviations)), float(np.mean(fitness_standard_deviations)), float(np.mean(maximum_entropies)), float(np.mean(maximum_fitnesses)), float(np.mean(minimum_entropies)), float(np.mean(minimum_fitnesses)), float(np.mean(population_diversities)), runs)

    return summary, evolutions


def run_experiment(configurations: List[Dict[str, object]], runs: int = 1, filename: str = 'summary.csv') -> tuple[List[ExperimentData], List[List[List[GeneticAlgorithmData]]]]:
    """
    Run a series of experiments for different configurations of the genetic algorithm and save the results to a CSV file.

    Args:
        configurations (List[Dict[str, object]]): A list of configuration dictionaries, each containing parameters for a different genetic algorithm configuration to run.
        runs (int, optional): The number of runs to perform for each configuration. Defaults to 1.
        filename (str, optional): The name of the CSV file to save the experiment results to. Defaults to 'summary.csv'.

    Returns:
        (results, evolutions) (Tuple[List[ExperimentData], List[List[List[GeneticAlgorithmData]]]]): A list of ExperimentData objects containing the summary metrics for each configuration and a list of evolution data for each configuration.
    """

    results = []
    evolutions = []

    # run each configuration and collect the summary metrics
    for configuration in configurations:
        print("Configuration:\n" + "-" * 14 + f"\n  - grid size: {GRID_WIDTH}x{GRID_HEIGHT},\n  - states: {configuration.get('states', '')},\n  - generations: {configuration.get('generations', '')},\n  - population size: {configuration.get('population_size', '')},\n  - elite size: {configuration.get('elite_size', '')},\n  - simulation steps: {configuration.get('simulation_steps', '')},\n  - last steps: {configuration.get('last_steps', '')},\n  - crossover rate: {configuration.get('crossover_rate', '')},\n  - mutation rate: {configuration.get('mutation_rate', '')}.\n\n" + "=" * 80 + "\n")
        summary, data = run_configuration(configuration, runs=runs)
        results.append(summary)
        evolutions.append(data)

    # sort the results by maximum fitness in descending order
    results.sort(key=lambda result: result.average_fitness, reverse=True)
    with open(filename, 'w', newline='') as file:

        # write the header and results
        writer = csv.writer(file)
        writer.writerow(['Average Entropy', 'Average Fitness', 'Entropy Standard Deviation', 'Fitness Standard Deviation', 'Population Diversity', 'Runs', 'States'])

        # write each configuration's summary metrics
        for result in results:
            writer.writerow([f"{result.average_entropy:.4f}", f"{result.average_fitness:.4f}", f"{result.entropy_standard_deviation:.4f}", f"{result.fitness_standard_deviation:.4f}", f"{result.population_diversity:.4f}", result.runs, result.configuration.get('states', '')])

    print(f"Saving experiment summary to '{filename}'...\n")

    return results, evolutions
