/**
 * @file mm.cpp
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Implementation of the MPI mesh multiplication algorithm.
 * @date 2026-04-13
 */

#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <mpi.h>

using namespace std;

#define FAIL 1
#define OK 0
#define TAG_A 1
#define TAG_B 2
#define TAG_R 3

/**
 * @brief Check whether a given string token represents a valid integer value (optionally negative).
 * @param token The string token to check.
 * @return true if the token is a valid integer, false otherwise.
 */
bool integer_check(const string &token) {
    if (token.empty()) {
        return false;
    }

    size_t start = (token[0] == '-') ? 1 : 0;
    if (start == token.size()) {
        return false;   // token is just a bare minus sign ('-' character)
    }

    for (size_t idx = start; idx < token.size(); ++idx) {
        if (!isdigit(token[idx])) {
            return false;
        }
    }

    return true;
}

/**
 * @brief Read integer values from a file and store them in a vector, while checking for input errors.
 * @param file The input file stream to read from.
 * @param out The vector to store the read integer values.
 * @param name The name of the file being read (used for error messages).
 * @return true if the input was successfully read and validated, false if an error was encountered.
 */
bool input_check(ifstream &file, vector<int> &out, const string &name) {
    string token;
    while (file >> token) {
        if (!integer_check(token)) {
            cerr << "\033[0;31mERROR:\033[0m Invalid input value '" << token << "' in file '" << name << "' (expected an integer value)." << endl;
            return false;
        }

        out.push_back(stoi(token));
    }

    return true;
}

/**
 * @brief Main function of the MPI mesh multiplication algorithm.
 * @param argc Number of command line arguments.
 * @param argv Array of command line arguments.
 * @return Exit code of the program.
 */
int main (int argc, char *argv[]) {
    // initialize MPI
    MPI_Init(&argc, &argv);

    // get the rank and size of the processes
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int m, n, k, o, tmp;
    vector<int> mat1, mat2;

    // read the input matrices from the files and check for errors on the root process
    if (rank == 0) {
        ifstream file1("mat1.txt");
        if (!file1.is_open()) {
            cerr << "\033[0;31mERROR:\033[0m Failed to open file 'mat1.txt'." << endl;
            MPI_Abort(MPI_COMM_WORLD, FAIL);
        }

        // read the first line to get the number of rows in the first matrix
        file1 >> m;
        if (!input_check(file1, mat1, "mat1.txt")) {
            MPI_Abort(MPI_COMM_WORLD, FAIL);
        }

        file1.close();
        if (mat1.size() % m != 0) {
            cerr << "\033[0;31mERROR:\033[0m The number of elements in 'mat1.txt' is not a multiple of " << m << "." << endl;
            MPI_Abort(MPI_COMM_WORLD, FAIL);
        }

        // calculate the number of columns in the first matrix
        n = mat1.size() / m;
        ifstream file2("mat2.txt");
        if (!file2.is_open()) {
            cerr << "\033[0;31mERROR:\033[0m Failed to open file 'mat2.txt'." << endl;
            MPI_Abort(MPI_COMM_WORLD, FAIL);
        }

        // read the first line to get the number of columns in the second matrix
        file2 >> k;
        if (!input_check(file2, mat2, "mat2.txt")) {
            MPI_Abort(MPI_COMM_WORLD, FAIL);
        }

        file2.close();
        if (mat2.size() % k != 0) {
            cerr << "\033[0;31mERROR:\033[0m The number of elements in 'mat2.txt' is not a multiple of " << k << "." << endl;
            MPI_Abort(MPI_COMM_WORLD, FAIL);
        }

        // calculate the number of rows in the second matrix
        o = mat2.size() / k;
        if (n != o) {
            cerr << "\033[0;31mERROR:\033[0m The number of columns in 'mat1.txt' (" << n << ") does not match the number of rows in 'mat2.txt' (" << o << ")." << endl;
            MPI_Abort(MPI_COMM_WORLD, FAIL);
        }

        if (size != m * k) {
            cerr << "\033[0;31mERROR:\033[0m The number of processes (" << size << ") does not match the required number (" << m * k << ")." << endl;
            MPI_Abort(MPI_COMM_WORLD, FAIL);
        }
    }

    // broadcast the dimensions of the matrices to all processes
    MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(&k, 1, MPI_INT, 0, MPI_COMM_WORLD);

    // calculate the position of the process in the mesh P(i, j)
    int i = rank / k;
    int j = rank % k;
    int cij = 0;

    // perform the multiplication using the mesh algorithm
    for (int l = 0; l < n; ++l) {
        int a, b;
        // get the value of 'a' from the left neighbor or from the root process
        if (j == 0) {
            if (rank == 0) {
                // take the value of 'a' from the process P(0, 0)
                a = mat1[i * n + l];
                // non-blocking send the value of 'a' to other processes in the same row
                vector<MPI_Request> req_a(m - 1);
                for (int row = 1; row < m; ++row) {
                    MPI_Isend(&(mat1[row * n + l]), 1, MPI_INT, row * k, TAG_A, MPI_COMM_WORLD, &req_a[row - 1]);
                }

                // take the value of 'b' from the process P(0, 0)
                b = mat2[l * k + j];
                // non-blocking send the value of 'b' to other processes in the same column
                vector<MPI_Request> req_b(k - 1);
                for (int col = 1; col < k; ++col) {
                    MPI_Isend(&(mat2[l * k + col]), 1, MPI_INT, col, TAG_B, MPI_COMM_WORLD, &req_b[col - 1]);
                }

                // wait for all non-blocking sends to complete before proceeding to the next iteration
                if (!req_a.empty()) {
                    MPI_Waitall(m - 1, req_a.data(), MPI_STATUSES_IGNORE);
                }

                if (!req_b.empty()) {
                    MPI_Waitall(k - 1, req_b.data(), MPI_STATUSES_IGNORE);
                }
            }

            // receive the value of 'a' from other processes in the same row P(i, 0)
            else {
                MPI_Recv(&a, 1, MPI_INT, 0, TAG_A, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            }
        }

        // receive the value of 'a' from the left neighbor P(i, j - 1)
        else {
            MPI_Recv(&a, 1, MPI_INT, rank - 1, TAG_A, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }

        // get the value of 'b' from the upper neighbor or from the root process
        if (i == 0) {
            if (rank == 0) {
                // the value of 'b' has already been taken from the process P(0, 0) and sent to other processes in the same column
            }

            // receive the value of 'b' from other processes in the same column P(0, j)
            else {
                MPI_Recv(&b, 1, MPI_INT, 0, TAG_B, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            }
        }

        // receive the value of 'b' from the upper neighbor P(i - 1, j)
        else {
            MPI_Recv(&b, 1, MPI_INT, rank - k, TAG_B, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }

        // calculate the partial product and add it to the current value of cij
        cij += a * b;
        // send the value of 'a' to the right neighbor P(i, j + 1) if it exists
        if (j < k - 1) {
            MPI_Send(&a, 1, MPI_INT, rank + 1, TAG_A, MPI_COMM_WORLD);
        }

        // send the value of 'b' to the lower neighbor P(i + 1, j) if it exists
        if (i < m - 1) {
            MPI_Send(&b, 1, MPI_INT, rank + k, TAG_B, MPI_COMM_WORLD);
        }
    }

    // gather the results and print the output matrix on the root process
    if (rank == 0) {
        cout << m << " " << k << endl;
        for (int r = 0; r < m; ++r) {
            for (int c = 0; c < k; ++c) {
                int value;
                if (r == 0 && c == 0) {
                    value = cij;
                }

                // receive the value of cij from other processes P(r, c)
                else {
                    MPI_Recv(&value, 1, MPI_INT, r * k + c, TAG_R, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                }

                cout << value;
                if (c < k - 1) {
                    cout << " ";
                }
            }

            cout << endl;
        }
    }

    // send the value of cij to the root process if it is not the root process
    else {
        MPI_Send(&cij, 1, MPI_INT, 0, TAG_R, MPI_COMM_WORLD);
    }

    // finalize MPI
    MPI_Finalize();
    return OK;
}
