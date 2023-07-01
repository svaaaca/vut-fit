/**
 * The C Programming Language
 * ==========================
 * 
 * 1st Project
 * Example: B
 * File: steg-decode.c
 * CC: gcc 9.4.0
 * 
 * Author: David Kvacek
 * Login: xkvace00; FIT
 * Date: 2022-03-23
 */

#include <stdio.h>
#include "bitset.h"
#include "eratosthenes.h"
#include "error.h"
#include "ppm.h"

#define START 29

int main(int argc, char * argv[]) {
    if(argc != 2) {
        error_exit("steg-decode: Neplatny pocet argumentu\n");
    }

    struct ppm * filedata = ppm_read(argv[1]);
    if(filedata == NULL) {
        warning_msg("steg-decode: Chyba alokace pameti\n");
    }
}
