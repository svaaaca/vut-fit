#!/usr/bin/env python3

__file__ = "ga.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Genetic algorithm module for evolving cellular automaton genomes."
__date__ = "2026-05-12"

import numpy as np
import random

from config import CROSSOVER_RATE, ELITE_SIZE, GENERATIONS, LAST_STEPS, MUTATION_RATE, POPULATION_SIZE, SIMULATION_STEPS, STATES
from dataclasses import dataclass
from evaluation import evaluate_genome
from genome import Genome
from typing import Dict, List, Tuple


@dataclass
class GeneticAlgorithmData:
    """Data class to hold statistics for each generation of the genetic algorithm."""

    average_entropy: float
    average_fitness: float
    best_genome: 'Genome'
    dynamic_equilibrium: float
    entropy_standard_deviation: float
    fitness_standard_deviation: float
    generation_number: int
    maximum_entropy: float
    maximum_fitness: float
    minimum_entropy: float
    minimum_fitness: float
    population_diversity: float
    stability: float


@dataclass
class ExperimentData:
    """Data class to hold summary statistics for a single run of the genetic algorithm with a specific configuration."""

    average_entropy: float
    average_fitness: float
    configuration: Dict[str, object]
    entropy_standard_deviation: float
    fitness_standard_deviation: float
    maximum_entropy: float
    maximum_fitness: float
    minimum_entropy: float
    minimum_fitness: float
    population_diversity: float
    runs: int


class GeneticAlgorithm:
    """Genetic algorithm for evolving cellular automaton rules."""
    
    def __init__(self: 'GeneticAlgorithm', crossover_rate: float = CROSSOVER_RATE, elite_size: int = ELITE_SIZE, last_steps: int = LAST_STEPS, mutation_rate: float = MUTATION_RATE, population_size: int = POPULATION_SIZE, simulation_steps: int = SIMULATION_STEPS,states: int = len(STATES)) -> None:
        """
        Initialize the genetic algorithm with a random population of genomes.

        Args:
            self (GeneticAlgorithm): The genetic algorithm instance.
            crossover_rate (float, optional): The probability of crossover between parents. Defaults to CROSSOVER_RATE.
            elite_size (int, optional): The number of top genomes to carry over unchanged to the next generation. Defaults to ELITE_SIZE.
            last_steps (int, optional): The number of last steps to consider for calculating fitness. Defaults to LAST_STEPS.
            mutation_rate (float, optional): The probability of mutating a child genome. Defaults to MUTATION_RATE.
            population_size (int, optional): The number of genomes in the population. Defaults to POPULATION_SIZE.
            simulation_steps (int, optional): The number of steps to run the simulation for each genome during evaluation. Defaults to SIMULATION_STEPS.
            states (int, optional): The number of states in the cellular automaton. Defaults to len(STATES).
        """

        self.crossover_rate = crossover_rate
        self.elite_size = elite_size
        self.fitness: List[float] = []
        self.generation = 0
        self.genomes: List[Genome] = []
        self.last_steps = last_steps
        self.mutation_rate = mutation_rate
        self.population: List[Genome] = [Genome(states) for _ in range(population_size)]
        self.population_size = population_size
        self.simulation_steps = simulation_steps
        self.states = states


    def _calculate_diversity(self: 'GeneticAlgorithm') -> float:
        """
        Calculate the average distance between genomes in the population to measure diversity.

        Args:
            self (GeneticAlgorithm): The genetic algorithm instance.

        Returns:
            diversity (float): The average distance between genomes in the population.
        """

        # if there are fewer than 2 genomes, diversity is zero
        if len(self.population) < 2:
            return 0.0

        # Sample pairs and compute average distance
        samples = min(10, len(self.population) * (len(self.population) - 1) // 2)
        total = 0.0

        # sample random pairs of genomes
        for _ in range(samples):
            i, j = random.sample(range(len(self.population)), 2)
            first, second = self.population[i], self.population[j]

            # calculate distance as the Euclidean distance between weights and thresholds
            distance = (np.sum((first.weights - second.weights) ** 2) + np.sum((first.thresholds - second.thresholds) ** 2)) ** 0.5
            total += distance

        # average distance is the total distance divided by the number of samples
        diversity = total / samples if samples > 0 else 0.0

        return diversity


    def evaluate_population(self: 'GeneticAlgorithm') -> List[Tuple[Genome, float, dict]]:
        """
        Evaluate the fitness of each genome in the population.

        Args:
            self (GeneticAlgorithm): The genetic algorithm instance.

        Returns:
            evaluation (List[Tuple[Genome, float, dict]]): A list of tuples containing each genome, its fitness and metrics.
        """

        evaluation = []

        # evaluate each genome and store its fitness and metrics
        for genome in self.population:
            fitness, metrics = evaluate_genome(genome, self.simulation_steps, self.last_steps)
            evaluation.append((genome, fitness, metrics))

        # sort by fitness descending
        evaluation.sort(key=lambda x: x[1], reverse=True)

        return evaluation


    def select_parents(self: 'GeneticAlgorithm', evaluation: List[Tuple[Genome, float, dict]], size: int = 3) -> Tuple[Genome, Genome]:
        """
        Select two parent genomes from the evaluated population using tournament selection.

        Args:
            self (GeneticAlgorithm): The genetic algorithm instance.
            evaluation (List[Tuple[Genome, float, dict]]): A list of tuples containing each genome, its fitness and metrics.
            size (int, optional): The number of genomes to include in the tournament. Defaults to 3.

        Returns:
            (first, second) (Tuple[Genome, Genome]): A tuple containing the two selected parent genomes.
        """

        def tournament() -> Genome:
            """
            Perform a tournament selection to choose one parent genome.

            Returns:
                best (Genome): The selected parent genome.
            """

            # randomly select 'size' genomes from the evaluation and return the one with the highest fitness
            indices = np.random.choice(len(evaluation), size, replace=False)
            best = evaluation[max(indices, key=lambda i: evaluation[i][1])][0].copy()

            return best

        # perform two tournaments to select two parent genomes
        first = tournament()
        second = tournament()

        return first, second


    def evolve(self: 'GeneticAlgorithm', generations: int = GENERATIONS) -> List[GeneticAlgorithmData]:
        """
        Evolve the population for a given number of generations.

        Args:
            self (GeneticAlgorithm): The genetic algorithm instance.
            generations (int, optional): The number of generations to evolve. Defaults to GENERATIONS.

        Returns:
            evolution (List[GeneticAlgorithmData]): A list of GeneticAlgorithmData objects containing statistics for each generation of the genetic algorithm.
        """

        evolution = []
        for generation_number in range(generations):

            # evaluate the current population
            evaluation = self.evaluate_population()
            fitnesses = [fitness for _, fitness, _ in evaluation]
            entropies = [metrics['average_entropy'] for _, _, metrics in evaluation]
            equilibriums = [metrics['dynamic_equilibrium'] for _, _, metrics in evaluation]
            stabilities = [metrics['stability'] for _, _, metrics in evaluation]

            fitness_standard_deviation = np.std(fitnesses)
            entropy_standard_deviation = np.std(entropies)
            maximum_fitness = fitnesses[0]
            minimum_fitness = np.min(fitnesses)
            average_fitness = np.mean(fitnesses)
            average_entropy = np.mean(entropies)
            maximum_entropy = np.max(entropies)
            minimum_entropy = np.min(entropies)
            average_equilibrium = np.mean(equilibriums)
            average_stability = np.mean(stabilities)
            best_genome = evaluation[0][0].copy()

            # store the best genome and fitness for this generation
            self.genomes.append(best_genome)
            self.fitness.append(maximum_fitness)

            # calculate population diversity (average distance between genomes)
            population_diversity = self._calculate_diversity()

            # store the statistics for this generation
            genetic_algorithm = GeneticAlgorithmData(average_entropy, average_fitness, best_genome, average_equilibrium, entropy_standard_deviation, fitness_standard_deviation, generation_number, maximum_entropy, maximum_fitness, minimum_entropy, minimum_fitness, population_diversity, average_stability)
            evolution.append(genetic_algorithm)

            # print generation statistics
            print(f"Generation {(generation_number + 1):2d}/{generations}:\n" + "-" * 17 + f"\n  - average entropy = {average_entropy:.4f},\n  - average fitness = {average_fitness:.4f},\n  - best genome = {best_genome},\n  - dynamic equilibrium = {average_equilibrium:.4f},\n  - population diversity = {population_diversity:.4f},\n  - stability = {average_stability:.4f}.\n")

            # create the next generation population
            population = []

            # keep the top elite genomes unchanged in the next generation
            for i in range(self.elite_size):
                population.append(evaluation[i][0].copy())

            # generate the rest of the population
            while len(population) < self.population_size:

                # select two parent genomes using tournament selection
                first, second = self.select_parents(evaluation)

                # crossover the parents to create a child genome with a certain probability, otherwise copy one of the parents
                if random.random() < self.crossover_rate:
                    child = first.crossover(second)

                else:
                    child = first.copy() if random.random() < 0.5 else second.copy()

                # mutate the child genome with a certain probability
                if random.random() < self.mutation_rate:
                    child.mutate()

                population.append(child)

            # sort the new population by fitness and keep only the top 'population_size' genomes for the next generation
            self.population = population[:self.population_size]
            self.generation = generation_number + 1

        return evolution


    def get_best_genome(self: 'GeneticAlgorithm') -> Genome:
        """
        Return the best genome from the current population.

        Args:
            self (GeneticAlgorithm): The genetic algorithm instance.

        Returns:
            best (Genome): The best genome from the current population.
        """

        best = self.genomes[-1].copy() if self.genomes else self.population[0].copy()

        return best
