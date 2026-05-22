#!/usr/bin/env python3

__file__ = "main.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Multi-state Cellular Automaton with Genetic Algorithm."
__date__ = "2026-05-12"

import argparse
import csv
import numpy as np

from automaton import CellularAutomaton
from config import CROSSOVER_RATE, ELITE_SIZE, GENERATIONS, GRID_HEIGHT, GRID_WIDTH, LAST_STEPS, MUTATION_RATE, POPULATION_SIZE, SIMULATION_STEPS, STATES
from evaluation import evaluate_genome, plot_metrics
from experiments import create_experiments, run_experiment
from ga import GeneticAlgorithm
from visualization import PygameVisualizer


def parse_arguments() -> argparse.Namespace:
    """
    Parse command-line arguments for running the genetic algorithm and experiments.

    Returns:
        parser (argparse.Namespace): The parsed command-line arguments.
    """

    parser = argparse.ArgumentParser(description='Multi-state Cellular Automaton with Genetic Algorithm.')
    parser.add_argument('--experiment', action='store_true', help='run a parameter sweep experiment with multiple configurations')
    parser.add_argument('--genome', type=str, default='genome.csv', help='path to a CSV output file to save the best genome metrics')
    parser.add_argument('--hide', action='store_true', help='hide the pygame visualization and only run the genetic algorithm')
    parser.add_argument('--metrics', type=str, default='metrics.png', help='path to a PNG output file to save the genetic algorithm metrics')
    parser.add_argument('--runs', type=int, default=1, help='number of runs per configuration in the experiment')
    parser.add_argument('--summary', type=str, default='summary.csv', help='path to a CSV output file to save the experiment results')
    parser = parser.parse_args()

    return parser


# ---------------------
# --- MAIN FUNCTION ---
# ---------------------

def main() -> None:
    """Main function to run the genetic algorithm and visualize the best genome's behavior in a cellular automaton."""

    # parse command-line arguments
    args = parse_arguments()

    # print the configuration and parameters of the genetic algorithm and cellular automaton
    print("\n" + "=" * 80 + "\n" + " " * 13 + "MULTI-STATE CELLULAR AUTOMATON WITH GENETIC ALGORITHM\n" + "=" * 80 + "\n")

    if not args.experiment:
        print("Configuration:\n" + "-" * 14 + f"\n  - grid size: {GRID_WIDTH}x{GRID_HEIGHT},\n  - states: {len(STATES)},\n  - generations: {GENERATIONS},\n  - population size: {POPULATION_SIZE},\n  - elite size: {ELITE_SIZE},\n  - simulation steps: {SIMULATION_STEPS},\n  - last steps: {LAST_STEPS},\n  - crossover rate: {CROSSOVER_RATE},\n  - mutation rate: {MUTATION_RATE}.")
        print("\n" + "=" * 80 + "\n")

    if args.experiment:
        configurations = create_experiments()
        results, evolutions = run_experiment(configurations, runs=args.runs, filename=args.summary)

        # extract evolution data for plotting (assuming runs=1, take first run per config)
        experiments = [evolution[0] if evolution else [] for evolution in evolutions]
        plot_metrics(args.metrics, experiments)

        if results:
            best = results[0]
            print("The best configuration found:\n" + "-" * 29 + f"\n  - average entropy = {best.average_entropy:.4f},\n  - average fitness = {best.average_fitness:.4f},\n  - entropy standard deviation = {best.entropy_standard_deviation:.4f},\n  - fitness standard deviation = {best.fitness_standard_deviation:.4f},\n  - population diversity = {best.population_diversity:.4f},\n  - runs = {best.runs},\n  - states = {best.configuration.get('states', '')}.")

        return

    # run the genetic algorithm to evolve cellular automaton rules
    genetic_algorithm = GeneticAlgorithm(POPULATION_SIZE, len(STATES))
    print("Starting the genetic algorithm evolution...\n")
    genetic_algorithm.evolve(GENERATIONS)

    # evaluate the best genome found by the genetic algorithm
    genome = genetic_algorithm.get_best_genome()
    fitness, metrics = evaluate_genome(genome)

    # print the best genome and its fitness and metrics
    print("=" * 80 + "\n\nThe best genome found:\n" + "-" * 22 + f"\n  - average entropy = {metrics['average_entropy']:.4f},\n  - average fitness = {fitness:.4f},\n  - dynamic equilibrium = {metrics['dynamic_equilibrium']:.4f},\n  - proportions = {np.array2string(metrics['proportions'], precision=4)},\n  - stability = {metrics['stability']:.4f},\n  - thresholds = {np.array2string(genome.thresholds, precision=4)},\n  - weights = {np.array2string(genome.weights, precision=4)}.\n\n" + "=" * 80 + "\n")

    # write the best genome's metrics
    if args.genome:
        with open(args.genome, 'w', newline='') as file:
            csv_writer = csv.writer(file)
            csv_writer.writerow(['Average Entropy', 'Average Fitness', 'Dynamic Equilibrium', 'Proportions', 'Stability', 'Thresholds', 'Weights'])
            csv_writer.writerow([f"{metrics['average_entropy']:.4f}", f"{fitness:.4f}", f"{metrics['dynamic_equilibrium']:.4f}", ', '.join(f"{x:.4f}" for x in metrics['proportions']), f"{metrics['stability']:.4f}", ', '.join(f"{x:.4f}" for x in genome.thresholds), ', '.join(f"{x:.4f}" for x in genome.weights)])

        print(f"Saving the best genome metrics to '{args.genome}'...")

    if args.hide:
        return

    print("\nLaunching visualization... (with the following keyboard controls):\n" + "-" * 66 + "\n  - C to clear the grid,\n  - N to perform one step forward (only when paused),\n  - R to reset the grid to a new random state,\n  - SPACE to run/pause the animation,\n  - UP/DOWN arrows to adjust the animation speed.")

    # initialize the cellular automaton and pygame visualizer, set the best genome, and run the visualization
    cellular_automaton = CellularAutomaton(len(STATES), GRID_WIDTH, GRID_HEIGHT)
    visualizer = PygameVisualizer(cellular_automaton)
    visualizer.set_genome(genome)
    visualizer.run()


# -------------------
# --- ENTRY POINT ---
# -------------------

if __name__ == "__main__":
    main()
