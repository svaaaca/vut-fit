/**
 * @file sui-solution.cc
 * @author Martin Burian (xburiam00@stud.fit.vutbr.cz)
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Implementation of a set of search algorithms.
 * @date 2025-11-17
 */

#include "memusage.h"
#include "search-interface.h"
#include "search-strategies.h"

#include <queue>
#include <set>
#include <stack>

std::vector<SearchAction> BreadthFirstSearch::solve(const SearchState &init_state)
{

    using PathState = std::pair<SearchState, std::vector<SearchAction>>;
    std::queue<PathState> frontier;

    std::set<SearchState> visited;

    if (init_state.isFinal())
        return {};

    frontier.push({SearchState(init_state), std::vector<SearchAction>{}});
    visited.insert(init_state);

    while (!frontier.empty())
    {

        if (getCurrentRSS() + (50 * 1024 * 1024) > this->mem_limit_)
            return {};

        PathState current_pair = std::move(frontier.front());
        frontier.pop();

        SearchState &current_state = current_pair.first;
        std::vector<SearchAction> &current_path = current_pair.second;

        for (const auto &action : current_state.actions())
        {

            SearchState next_state = action.execute(current_state);

            if (visited.find(next_state) == visited.end())
            {

                std::vector<SearchAction> next_path = current_path;
                next_path.push_back(action);

                if (next_state.isFinal())
                {
                    return next_path;
                }

                visited.insert(next_state);
                frontier.push({std::move(next_state), std::move(next_path)});
            }
        }
    }

    return {};
}

std::vector<SearchAction> DepthFirstSearch::solve(const SearchState &init_state)
{

    using PathState = std::pair<SearchState, std::vector<SearchAction>>;
    std::stack<PathState> frontier;

    std::set<SearchState> visited;

    if (init_state.isFinal())
        return {};

    frontier.push({SearchState(init_state), std::vector<SearchAction>{}});
    visited.insert(init_state);

    while (!frontier.empty())
    {

        if (getCurrentRSS() + (50 * 1024 * 1024) > this->mem_limit_)
            return {};

        PathState current_pair = std::move(frontier.top());
        frontier.pop();

        SearchState &current_state = current_pair.first;
        std::vector<SearchAction> &current_path = current_pair.second;

        for (const auto &action : current_state.actions())
        {

            SearchState next_state = action.execute(current_state);

            if (visited.find(next_state) == visited.end())
            {

                std::vector<SearchAction> next_path = current_path;
                next_path.push_back(action);

                if (next_state.isFinal())
                {
                    return next_path;
                }

                visited.insert(next_state);
                frontier.push({std::move(next_state), std::move(next_path)});
            }
        }
    }

    return {};
}

double StudentHeuristic::distanceLowerBound(const GameState &state) const
{
    return 0;
}

struct AStarNode
{

    SearchState state;
    std::vector<SearchAction> path;
    double cost;
    double f_score;

    bool operator>(const AStarNode &other) const
    {
        return f_score > other.f_score;
    }
};

std::vector<SearchAction> AStarSearch::solve(const SearchState &init_state)
{

    if (init_state.isFinal())
        return {};

    std::priority_queue<AStarNode, std::vector<AStarNode>, std::greater<AStarNode>> frontier;
    std::set<SearchState> visited;

    double h0 = compute_heuristic(init_state, *heuristic_);
    frontier.push({SearchState(init_state), {}, 0.0, h0});
    visited.insert(init_state);

    while (!frontier.empty()) {

        if (getCurrentRSS() + (50 * 1024 * 1024) > this->mem_limit_)
            return {};

        AStarNode current = frontier.top();
        frontier.pop();

        if (current.state.isFinal())
        {
            return current.path;
        }

        for (const auto &action : current.state.actions())
        {

            SearchState next_state = action.execute(current.state);

            if (visited.find(next_state) != visited.end())
                continue;

            std::vector<SearchAction> next_path = current.path;
            next_path.push_back(action);

            double g = next_path.size();
            double h = compute_heuristic(next_state, *heuristic_);
            double f = g + h;

            frontier.push({std::move(next_state), std::move(next_path), g, f});
            visited.insert(next_state);
        }
    }

    return {};
}
