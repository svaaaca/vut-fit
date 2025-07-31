/**
 * @file vuv.cpp
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Implementation of the binary tree top level algorithm using the Open MPI library.
 * @date 2025-05-04
 */

#include <iostream>
#include <mpi.h>
#include <string>
#include <vector>

#define BUFFER_SIZE 32  // Number of entries in the buffer.
#define COUNT 1         // Number of buffer elements.
#define FAIL 1          // Return code for failed execution.
#define LEVEL_TAG 0     // Tag for sending levels.
#define OK 0            // Return code for successful execution.
#define RESULT_TAG 1    // Tag for sending results.
#define ROOT_RANK 0     // Rank of the root process.

/**
 * @brief Computing the left child index in a binary tree.
 * @param index Index of the current node.
 * @return Index of the left child.
 */
int left_child(int index) {
    return 2 * index + 1;
}

/**
 * @brief Computing the right child index in a binary tree.
 * @param index Index of the current node.
 * @return Index of the right child.
 */
int right_child(int index) {
    return 2 * index + 2;
}

int main(int argc, char *argv[]) {
    // initialize the MPI environment
    MPI_Init(&argc, &argv);

    // get the rank and size of the MPI communicator
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // check if the number of arguments is correct
    if (argc != 2) {
        if (rank == ROOT_RANK) {
            std::cerr << "ERROR: exactly one argument is required (node identifiers)!" << std::endl;
        }

        // finalize the MPI environment
        MPI_Finalize();
        return FAIL;
    }

    // store the node identifiers
    std::string nodes(argv[1]);

    // check if the number of processes matches the number of nodes
    if (nodes.size() != static_cast<size_t>(size)) {
        if (rank == ROOT_RANK) {
            std::cerr << "ERROR: the number of MPI processes must match the number of nodes!" << std::endl;
        }

        // finalize the MPI environment
        MPI_Finalize();
        return FAIL;
    }

    // variables for the current node and its level
    char node = nodes[rank];
    int level = -1;

    // process 0 starts with level 0
    if (rank == ROOT_RANK) {
        level = 0;
    }

    else {
        // receive level from the parent node
        MPI_Recv(&level, COUNT, MPI_INT, MPI_ANY_SOURCE, LEVEL_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        level += 1;
    }

    // compute the left and right child indices
    int left = left_child(rank);
    int right = right_child(rank);

    // check if the left child is within bounds
    if (left < size) {
        // send level to the left child
        MPI_Send(&level, COUNT, MPI_INT, left, LEVEL_TAG, MPI_COMM_WORLD);
    }

    // check if the right child is within bounds
    if (right < size) {
        // send level to the right child
        MPI_Send(&level, COUNT, MPI_INT, right, LEVEL_TAG, MPI_COMM_WORLD);
    }

    // format the local result
    std::string result = std::string(COUNT, node) + ":" + std::to_string(level);

    // gather results from all processes to the root process
    if (rank == ROOT_RANK) {
        std::string output = result;
        char buffer[BUFFER_SIZE];

        // receive results from all other processes
        for (int i = 1; i < size; ++i) {
            MPI_Recv(buffer, sizeof(buffer), MPI_CHAR, i, RESULT_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            output += "," + std::string(buffer);
        }

        // print the final output
        std::cout << output << std::endl;
    }

    else {
        // send the result to the root process
        MPI_Send(result.c_str(), result.size() + 1, MPI_CHAR, ROOT_RANK, RESULT_TAG, MPI_COMM_WORLD);
    }

    // finalize the MPI environment
    MPI_Finalize();
    return OK;
}
