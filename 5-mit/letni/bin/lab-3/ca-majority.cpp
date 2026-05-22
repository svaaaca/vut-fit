#include <iostream>
#include <vector>
#include <tuple>
#include <algorithm>

#include "individual.hpp"
#include "simulator.hpp"
#include "canrun.h"

int main(int argc, char **argv)
{

    /* Configuration */
    const int var_mu = 10;        // Parent population
    const int var_lambda = 20;    // Offspring population
    const int var_mutations = 2;  // Number of mutations
    const int cells = 11;         // No. of 1D cells
    const int steps = 20;         // Maximal number of steps
    const int simulations = 1000; // Number of initial states
    const int neighbours = 2;     // Number of neighbours - 1, 2, or 3
    const int generations = 1000; // Number of generations

    const int var_pop = var_mu + var_lambda;
    Simulator sim(cells, steps, simulations);
    canrun_init();              // Initialize ctrl+c command

    // Initialize random state generator
    srand(time(NULL));

    // Create random parent and children population
    std::vector<Individual> newParent;       // buffer for the result of current generation
    std::vector<Individual> population;

    for (int i = 0; i < var_pop; i++)
    {
        population.emplace_back(neighbours); // construct
        population[i].randomInit();

        if (i < var_mu)
            newParent.emplace_back(neighbours);
    }

    int gen = 0;
    int best_fit = 0;
    Individual bestIndiv(neighbours);

    std::vector<std::tuple<int, int>> fitness(var_pop); // fitness is stored as a tuple: id, fitness value

    std::cout << "Starting evolution, press Ctrl+C to interrupt" << std::endl;

    auto startTime = cpuTime();

    for (gen = 0; canrun && gen < generations; gen++)
    {
        // Create new population from the previous parents
        for (int i = var_mu; i < var_pop; i++)
        {
            population[i].crossoverFrom(population[rand() % var_mu], population[rand() % var_mu]);
            population[i].mutate(rand() % (var_mutations + 1));
        }

        // Evaluate all individuals by simulator
        for (int i = 0; i < var_pop; i++)
        {
            fitness[i] = std::tuple<int, int>(i, sim.simulate(&(population[i])));
        }

        // Sort by fitness (descending)
        std::sort(fitness.begin(), fitness.end(),
                  [](std::tuple<int, int> &a, std::tuple<int, int> &b)
                  { return std::get<1>(a) > std::get<1>(b); });

        // For var_mu best individuals copy to buffer newParent
        for (int i = 0; i < var_mu; i++)
        {
            int id, fit;
            std::tie(id, fit) = fitness[i];
            newParent[i] = population[id];

            if (fit > best_fit)
            {
                std::cout << "## gen=" << gen << ";time=" << (cpuTime() - startTime) << ";fitness=" << fit << std::endl;
                best_fit = fit;
                bestIndiv = population[id];
            }
        }

        // finally copy newParent to population
        for (int i = 0; i < var_mu; i++)
        {
            population[i] = newParent[i];
        }
    } /* foreach gen */

    // Run simulation once again to get
    sim.simulate(&bestIndiv);
    std::cout << std::endl
              << std::endl
              << "\033[92mFound solution:\033[90m" << std::endl
              << bestIndiv << "\033[0m" << std::endl
              << "\033[91mStatistics: \033[0m" << std::endl
              << sim << std::endl
              << "   runtime: " << (cpuTime() - startTime) << " s" << std::endl
              << "   evaluationTime: " << (cpuTime() - startTime) / (gen * var_pop) << " s/indiv" << std::endl
              << "   generations: " << gen << std::endl;
}
