/**
 * The C Programming Language
 * ==========================
 * 
 * 1st Project
 * Example: A
 * File: bitset.h
 * CC: gcc 9.4.0
 * 
 * Author: David Kvacek
 * Login: xkvace00; FIT
 * Date: 2022-03-23
 */

#ifndef BITSET_H
#define BITSET_H

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <assert.h>
#include "error.h"

typedef unsigned long * bitset_t;
typedef unsigned long bitset_index_t;

#define BITSET_SIZE (CHAR_BIT * sizeof(bitset_index_t))
#define ARRAY_SIZE(velikost) (((velikost) % BITSET_SIZE) == 0 ? (((velikost) / BITSET_SIZE) + 1) : (((velikost) / BITSET_SIZE) + 2))
#define PRIMES 300000000

#define bitset_create(jmeno_pole, velikost)\
        bitset_index_t jmeno_pole[ARRAY_SIZE(velikost)] = {velikost, 0, };\
        static_assert(velikost > 0 && velikost <= PRIMES, "bitset_create: Velikost pole musí být v rozsahu 0..300000000\n")

#define bitset_alloc(jmeno_pole, velikost)\
        bitset_t jmeno_pole = calloc(ARRAY_SIZE(velikost), sizeof(bitset_index_t));\
        static_assert(velikost > 0 && velikost < PRIMES, "bitset_alloc: Velikost pole musí být v rozsahu 0..300000000\n");\
        if(jmeno_pole == NULL) error_exit("bitset_alloc: Chyba alokace paměti\n");\
        jmeno_pole[0] = velikost

#ifndef USE_INLINE

    #define bitset_free(jmeno_pole)\
            free(jmeno_pole)

    #define bitset_size(jmeno_pole)\
            jmeno_pole[0]

    #define bitset_setbit(jmeno_pole, index, vyraz)\
            (((index) > (bitset_size(jmeno_pole))) ?\
            (error_exit("bitset_setbit: Index %lu mimo rozsah 0..%lu\n", (bitset_index_t)(index), (bitset_index_t)bitset_size(jmeno_pole))), 0 :\
            ((!(vyraz)) ? (jmeno_pole[((index) / BITSET_SIZE) + 1] &= (~(1UL << ((index) % BITSET_SIZE)))), 0 :\
                          (jmeno_pole[((index) / BITSET_SIZE) + 1] |= (1UL << ((index) % BITSET_SIZE)))))

    #define bitset_getbit(jmeno_pole, index)\
            (((index) > (bitset_size(jmeno_pole))) ?\
            (error_exit("bitset_getbit: Index %lu mimo rozsah 0..%lu\n", (bitset_index_t)(index), (bitset_index_t)bitset_size(jmeno_pole))), 0 :\
            ((jmeno_pole[((index) / BITSET_SIZE) + 1] & (1UL << ((index) % BITSET_SIZE))) >> ((index) % BITSET_SIZE)))

#else

    static inline void bitset_free(bitset_t jmeno_pole) {
        free(jmeno_pole);
    }

    static inline bitset_index_t bitset_size(bitset_t jmeno_pole) {
        return jmeno_pole[0];
    }

    static inline void bitset_setbit(bitset_t jmeno_pole, bitset_index_t index, bitset_index_t vyraz) {
        if(index > (bitset_size(jmeno_pole))) {
            error_exit("bitset_setbit: Index %lu mimo rozsah 0..%lu\n", (bitset_index_t)index, (bitset_index_t)bitset_size(jmeno_pole));
        }
        if(!vyraz) {
            jmeno_pole[(index / BITSET_SIZE) + 1] &= (~(1UL << (index % BITSET_SIZE)));
        }
        else {
            jmeno_pole[(index / BITSET_SIZE) + 1] |= (1UL << (index % BITSET_SIZE));
        }
    }

    static inline bitset_index_t bitset_getbit(bitset_t jmeno_pole, bitset_index_t index) {
        if(index > (bitset_size(jmeno_pole))) {
            error_exit("bitset_getbit: Index %lu mimo rozsah 0..%lu\n", (bitset_index_t)index, (bitset_index_t)bitset_size(jmeno_pole));
        }
        return (jmeno_pole[(index / BITSET_SIZE) + 1] & (1UL << (index % BITSET_SIZE))) >> (index % BITSET_SIZE);
    }

#endif
#endif
