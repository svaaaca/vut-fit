#pragma once
#include <cassert>
#include <cstdlib>
#include <iostream>
#include <cstring>
#include <algorithm>
#include <vector>

class Individual;

class Individual
{
public:
    // Random initialization
    Individual(int neighbours) : data(1 << (2 * neighbours + 1))
    {
        assert(neighbours >= 1 && neighbours <= 3);
        this->neighbours = neighbours;
        this->genomes = 1 << (2 * neighbours + 1);
    }

    void randomInit()
    {
        for (auto &i : data)
        {
            i = rand() % 2;
        }
    }

    void crossoverFrom(const Individual &a, const Individual &b)
    {
        assert(a.genomes == b.genomes);
        assert(genomes == a.genomes);

        // point-based crossover
        int j = rand() % genomes;
        for (int i = 0; i < genomes; i++)
        {
            data[i] = i < j ? a.data[i] : b.data[i];
        }
    }

    void mutate(const int nodes)
    {
        for (int i = 0; i < nodes; i++)
        {
            int id = rand() % this->genomes;
            data[id] = !data[id];
        }
    }

    int getRule(int ruleId)
    {
        assert(ruleId >= 0);
        assert(ruleId < this->genomes);

        return data[ruleId] & 0x1;
    }

    friend std::ostream &operator<<(std::ostream &cout, const Individual &indiv)
    {
        cout << "{\"neighborhood\":" << indiv.neighbours << ", \"data\": ";

        cout << "[";

        for (int i = 0; i < indiv.genomes; i++)
        {
            if (i)
                cout << ",";
            cout << indiv.data[i];
        }
        cout << "]}";
        return cout;
    }

    Individual &operator=(Individual &a)
    {
        assert(a.genomes == this->genomes);
        this->data = a.data;
        return *this;
    }

    std::vector<int> data;
    int neighbours;

protected:
    int genomes;
};
