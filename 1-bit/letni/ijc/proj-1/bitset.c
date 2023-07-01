/**
 * The C Programming Language
 * ==========================
 * 
 * 1st Project
 * Example: A
 * File: bitset.c
 * CC: gcc 9.4.0
 * 
 * Author: David Kvacek
 * Login: xkvace00; FIT
 * Date: 2022-03-23
 */

#include "bitset.h"

#ifdef USE_INLINE

    extern void bitset_free(bitset_t jmeno_pole);
    extern bitset_index_t bitset_size(bitset_t jmeno_pole);
    extern void bitset_setbit(bitset_t jmeno_pole, bitset_index_t index, bitset_index_t vyraz);
    extern bitset_index_t bitset_getbit(bitset_t jmeno_pole, bitset_index_t index);

#endif
