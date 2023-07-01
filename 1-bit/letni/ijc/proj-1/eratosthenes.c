/**
 * The C Programming Language
 * ==========================
 * 
 * 1st Project
 * Example: A
 * File: eratosthenes.c
 * CC: gcc 9.4.0
 * 
 * Author: David Kvacek
 * Login: xkvace00; FIT
 * Date: 2022-03-23
 */

#include "bitset.h"
#include "eratosthenes.h"

void Eratosthenes(bitset_t pole) {
    bitset_index_t i, j;
    bitset_setbit(pole, 1, 1);
    for(i = 2; i < bitset_size(pole); i++) {
        bitset_setbit(pole, i, 0);
    }

    for(i = 2; i * i < bitset_size(pole); i++) {
        if(!(bitset_getbit(pole, i))) {
            for(j = 2 * i; j < bitset_size(pole); j += i) {
                bitset_setbit(pole, j, 1);
            }
        }
    }
}
