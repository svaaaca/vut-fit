#pragma once
#include "individual.hpp"
#include <cstring>
#include <iostream>
#include <cassert>
#include <vector>

class Simulator;

class Simulator
{
public:
    Simulator(int cells, int steps, int states) : expected(states)
    {
        if (cells % 2 != 1) // only odd numbers!
            throw std::logic_error("Only odd number of cells allowed");
        this->states = states;

        buffer.resize(2, std::vector<int>(cells));     // two lines of CA
        data.resize(states, std::vector<int>(cells));  // initial (random) states

        this->steps = steps;
        this->cells = cells;

        this->generateRandomStates();
    }

    
    int simulate(Individual *indiv)
    {
        int fit = 0;

        /* Statistika */
        this->validStates = 0;
        this->stableStates = 0;

        // Run the simulation for `steps` steps
        for (int state = 0; state < this->states; state++)
        {
            // IDs of buffers, each step the IDs are switched
            int current = 0;
            int future = 1;

            buffer[current] = data[state]; // Fill 

            int state_fitness = 0; // fitness of current state

            // Run the simulation for `steps` steps
            for (int step = 0; step < this->steps; step++)
            {
                for (int cell = 0; cell < this->cells; cell++)
                {
                    // Getting the rule id: id 0 = all cells off; 0b0001 - the left cell is active, rest inactive
                    // be aware of the borders
                    int ruleId = 0;

                    if (indiv->neighbours == 1)
                    {
                        ruleId =
                            (buffer[current][this->getCellID(cell - 1)]) |      // cell - 1    * 1   (+ checks)
                            (buffer[current][cell]) << 1 |                      // cell        * 2  (+ checks)
                            (buffer[current][this->getCellID(cell + 1)]) << 2;  // cell + 1    * 4 (+ checks)
                    }
                    else if (indiv->neighbours == 2) {
                        ruleId =
                            (buffer[current][this->getCellID(cell - 2)]) |  
                            (buffer[current][this->getCellID(cell - 1)]) << 1 | 
                            (buffer[current][cell]) << 2 |
                            (buffer[current][this->getCellID(cell + 1)]) << 3 |
                            (buffer[current][this->getCellID(cell + 2)]) << 4;
                    } 
                    else if (indiv->neighbours == 3) {
                        ruleId =
                            (buffer[current][this->getCellID(cell - 3)]) |  
                            (buffer[current][this->getCellID(cell - 2)]) << 1|  
                            (buffer[current][this->getCellID(cell - 1)]) << 2 | 
                            (buffer[current][cell]) << 3 |
                            (buffer[current][this->getCellID(cell + 1)]) << 4 |
                            (buffer[current][this->getCellID(cell + 2)]) << 5 |
                            (buffer[current][this->getCellID(cell + 3)]) << 6;
                    }
                    else
                    {
                        throw std::logic_error("Invalid number of neighbours");
                    }

                    buffer[future][cell] = indiv->getRule(ruleId);
                }
                // calculate the row_fitness: how many cells in the future buffer
                // has the same value as the majority of a vector data[state]. To 
                // avoid a calculation in all steps, this value is stored in expected[state]
                // include the bonus if all cells have same (correct) value.

                // store the row_fitness to variable state_fitness

                // @TODO: task 1: state_fitness = maximum of all row_fitnesses
                int row_fitness = 0;

                // @TODO: task 2: update the previous code to handle only the stable state
                if (buffer[current] == buffer[future]) {
                    for (int cell = 0; cell < this->cells; cell++) {
                        if (buffer[future][cell] == expected[state]) {
                            row_fitness++;
                        }
                    }

                    if (row_fitness == this->cells) {
                        row_fitness *= 10; // bonus for all cells having the same value
                        step = this->steps; // break the loop, we have reached the stable state
                    }

                    if (row_fitness > state_fitness) {
                        state_fitness = row_fitness;
                    }
                }

                // @TODO: task 3: remove the bonus (*10) for the valid states (all cells have the same valid value)

                // Switch current and future buffers
                current ^= 1;
                future ^= 1;
            } /* foreach step */

            fit += state_fitness;

            // some statistics:
            if(state_fitness >= cells) this->validStates++;
            if(buffer[current] == buffer[future]) this->stableStates++;

        } /* foreach state */

        fitness = fit; // store last fitness
        return fit;
    }

    // Print statistics
    friend std::ostream &operator<<(std::ostream &cout, const Simulator &s)
    {
        cout
            << "   validStates: " << s.validStates << " (" << (100.0 * s.validStates / s.states) << "%)" << std::endl
            << "   stableStates: " << s.stableStates << " (" << (100.0 * s.stableStates / s.states) << "%)" << std::endl
            << "   totalStates: " << s.states << std::endl
            << "   cells: " << s.cells << std::endl
            << "   fitness: " << s.fitness;

        return cout;
    }

private:
    // Randomly initialize the inial states (same for whole evolution)
    void generateRandomStates()
    {
        for (int i = 0; i < this->states; i++)
        {
            int sum = 0;
            for (int c = 0; c < this->cells; c++)
            {
                data[i][c] = rand() & 0x01;
                sum += data[i][c];
            }

            expected[i] = sum * 2 > this->cells; // calculated majority
        }
    }

    inline int getCellID(int pos) {
        if (pos < 0)
            return 0;
        else if (pos >= this->cells)
            return this->cells - 1;
        else
            return pos;
    }

    int states;
    int steps;
    int cells;

    std::vector<std::vector<int>> data;     // Initial states; shape: (states, cells)
    std::vector<int> expected;              // Expected majority; shape: (states)
    std::vector<std::vector<int>> buffer;   // Buffer for simulation; shape: (2, cells)

    /* Statistics */
    int stableStates;
    int validStates;
    int fitness; // last fitness
};
