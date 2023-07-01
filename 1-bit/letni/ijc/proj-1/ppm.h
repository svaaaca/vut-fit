/**
 * The C Programming Language
 * ==========================
 * 
 * 1st Project
 * Example: B
 * File: ppm.h
 * CC: gcc 9.4.0
 * 
 * Author: David Kvacek
 * Login: xkvace00; FIT
 * Date: 2022-03-23
 */

#ifndef PPM_H
#define PPM_H

struct ppm {
    unsigned xsize;
    unsigned ysize;
    char data[];
};

struct ppm * ppm_read(const char * filename);
void ppm_free(struct ppm * ppm);

#endif
