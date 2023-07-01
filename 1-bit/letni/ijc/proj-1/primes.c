/**
 * The C Programming Language
 * ==========================
 * 
 * 1st Project
 * Example: A
 * File: primes.c
 * CC: gcc 9.4.0
 * 
 * Author: David Kvacek
 * Login: xkvace00; FIT
 * Date: 2022-03-23
 */

#include <stdio.h>
#include <time.h>
#include "bitset.h"
#include "eratosthenes.h"

#define PRINT 10

int main() {
    bitset_index_t i, j = 10, primes[PRINT];
    clock_t start = clock();

    bitset_create(p, PRIMES);
    Eratosthenes(p);

    for(i = bitset_size(p) - 1; j >= 1; i--) {
        if(!(bitset_getbit(p, i))) {
            primes[j-1] = i;
            j--;
        }
    }

    for(i = 0; i < 10; i++) {
        printf("%lu\n", primes[i]);
    }

    fprintf(stderr, "Time=%.3g\n", (double)(clock()-start) / CLOCKS_PER_SEC);
}
