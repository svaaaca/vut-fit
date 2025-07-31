/**
 * @file oets.cpp
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Implementation of the odd-even transposition sort algorithm using the Open MPI library.
 * @date 2025-04-06
 */

#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <mpi.h>
#include <numeric>
#include <vector>

#define BUFFER_SIZE 1   // Number of entries in the buffer.
#define OK 0            // Return code for successful execution.
#define FAIL 1          // Return code for failed execution.
#define ROOT_RANK 0     // Rank of the root process.
#define SEND_TAG 0      // Tag for sending data.
#define SOURCE_RANK 0   // Rank of the source process.

/**
 * @brief Reading a binary file into a vector of bytes.
 * @param filename Name of the file to read.
 * @return Vector containing the bytes read from the file.
 */
std::vector<uint8_t> read_data(const std::string &filename) {
    // open the file in binary mode
    std::ifstream file(filename, std::ios::binary);

    // check if the file is opened successfully
    if (!file) {
        std::cerr << "ERROR: file '" << filename << "' cannot be opened!" << std::endl;
        MPI_Abort(MPI_COMM_WORLD, FAIL);
    }

    // read the file content into a vector
    return std::vector<uint8_t>((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
}

/**
 * @brief Computing the distribution of elements among processes.
 * @param distribution Total number of elements to distribute.
 * @param size Number of processes.
 * @param element Vector containing the number of elements for each process.
 * @param displacement Vector containing the displacement for each process.
 */
void compute_distribution(int distribution, int size, std::vector<int> &element, std::vector<int> &displacement) {
    // resize the vectors to hold the number of elements and displacement for each process
    element.resize(size);
    displacement.resize(size);

    // compute the number of elements and displacement for each process
    for (int process = 0; process < size; ++process) {
        element[process] = distribution / size + (process < distribution % size ? 1 : 0);
        displacement[process] = (process == 0) ? 0 : displacement[process - 1] + element[process - 1];
    }
}

/**
 * @brief Broadcasting the distribution of elements to all processes.
 * @param distribution Total number of elements to distribute.
 * @param size Number of processes.
 * @param element Vector containing the number of elements for each process.
 * @param displacement Vector containing the displacement for each process.
 */
void broadcast_distribution(int &distribution, int size, std::vector<int> &element, std::vector<int> &displacement) {
    // broadcast the total number of elements to all processes
    MPI_Bcast(&distribution, BUFFER_SIZE, MPI_INT, ROOT_RANK, MPI_COMM_WORLD);

    // resize the vectors to hold the number of elements and displacement for each process
    element.resize(size);
    displacement.resize(size);

    // broadcast the number of elements and displacement for each process
    MPI_Bcast(element.data(), size, MPI_INT, ROOT_RANK, MPI_COMM_WORLD);
    MPI_Bcast(displacement.data(), size, MPI_INT, ROOT_RANK, MPI_COMM_WORLD);
}

/**
 * @brief Scattering the input data from the root process to all processes.
 * @param global Vector containing the global input data.
 * @param element Vector containing the number of elements for each process.
 * @param displacement Vector containing the displacement for each process.
 * @param rank Rank of the current process.
 * @param size Number of processes.
 * @return Vector containing the local data for the current process.
 */
std::vector<uint8_t> scatter_data(const std::vector<uint8_t> &global, const std::vector<int> &element, const std::vector<int> &displacement, int rank, int size) {
    // vector to hold the local data for the current process
    std::vector<uint8_t> local(element[rank]);

    // scatter the data to all processes
    MPI_Scatterv(global.data(), element.data(), displacement.data(), MPI_UINT8_T, local.data(), element[rank], MPI_UINT8_T, ROOT_RANK, MPI_COMM_WORLD);
    return local;
}

/**
 * @brief Odd-even transposition sort parallel algorithm.
 * @param local Vector containing the local data for the current process.
 * @param element Vector containing the number of elements for each process.
 * @param rank Rank of the current process.
 * @param size Number of processes.
 */
void odd_even_transposition_sort(std::vector<uint8_t> &local, const std::vector<int> &element, int rank, int size) {
    // iteration through the phases exchanging data between processes
    for (int phase = 0; phase < size; ++phase) {
        // initialize the partner rank
        int partner = -1;

        // exchange even ranks with odd ranks
        if (phase % 2 == 0) {
            partner = (rank % 2 == 0) ? rank + 1 : rank - 1;
        }

        // exchange odd ranks with even ranks
        else {
            partner = (rank % 2 == 0) ? rank - 1 : rank + 1;
        }

        // check if the partner rank is within valid range
        if (partner < 0 || partner >= size) {
            continue;
        }

        // vector to hold the data from the partner process
        std::vector<uint8_t> data(element[partner]);

        // send and receive data between the local process and the partner process
        MPI_Sendrecv(local.data(), element[rank], MPI_UINT8_T, partner, SEND_TAG, data.data(), element[partner], MPI_UINT8_T, partner, SOURCE_RANK, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        // merge and sort the local data with the data received from the partner process
        std::vector<uint8_t> merge(local);
        merge.insert(merge.end(), data.begin(), data.end());
        std::sort(merge.begin(), merge.end());

        // copy the first half of the merged data
        if (rank < partner) {
            std::copy(merge.begin(), merge.begin() + element[rank], local.begin());
        }

        // copy the second half of the merged data
        else {
            std::copy(merge.end() - element[rank], merge.end(), local.begin());
        }
    }
}

/**
 * @brief Gathering and printing the sorted data from all processes to the root process.
 * @param local Vector containing the local sorted data for the current process.
 * @param element Vector containing the number of elements for each process.
 * @param displacement Vector containing the displacement for each process.
 * @param size Total number of elements.
 * @param rank Rank of the current process.
 */
void gather_data(const std::vector<uint8_t> &local, const std::vector<int> &element, const std::vector<int> &displacement, int size, int rank) {
    // vector to hold the global sorted data
    std::vector<uint8_t> global;

    // resize the global vector to hold the total number of elements only on the root process
    if (rank == ROOT_RANK) {
        global.resize(size);
    }

    // gather the sorted data from all processes to the root process
    MPI_Gatherv(local.data(), element[rank], MPI_UINT8_T, global.data(), element.data(), displacement.data(), MPI_UINT8_T, ROOT_RANK, MPI_COMM_WORLD);

    // print the sorted data only on the root process
    if (rank == ROOT_RANK) {
        for (uint8_t value : global) {
            std::cout << static_cast<int>(value) << std::endl;
        }
    }
}

int main(int argc, char *argv[]) {
    // initialize the MPI environment
    MPI_Init(&argc, &argv);

    // get the rank and size of the MPI communicator
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // vectors to hold the global input data, number of elements, and displacement for each process
    std::vector<uint8_t> global;
    std::vector<int> element, displacement;
    int total = 0;

    // read the input data only on the root process
    if (rank == ROOT_RANK) {
        global = read_data("numbers");
        total = global.size();

        // print the input data
        for (uint8_t value : global) {
            std::cout << static_cast<int>(value) << " ";
        }

        std::cout << std::endl;

        // compute the distribution of elements among processes
        compute_distribution(total, size, element, displacement);
    }

    // broadcast the total number of elements to all processes
    broadcast_distribution(total, size, element, displacement);

    // scatter the input data, sort the data locally, and perform parallel odd-even transposition sort
    auto local = scatter_data(global, element, displacement, rank, size);
    std::sort(local.begin(), local.end());
    odd_even_transposition_sort(local, element, rank, size);

    // gather the sorted data from all processes to the root process and print it
    gather_data(local, element, displacement, total, rank);

    // finalize the MPI environment
    MPI_Finalize();
    return OK;
}
