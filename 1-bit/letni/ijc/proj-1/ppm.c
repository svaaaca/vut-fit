/**
 * The C Programming Language
 * ==========================
 * 
 * 1st Project
 * Example: B
 * File: ppm.c
 * CC: gcc 9.4.0
 * 
 * Author: David Kvacek
 * Login: xkvace00; FIT
 * Date: 2022-03-23
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "error.h"
#include "ppm.h"

#define LIMIT (8000*8000*3)
#define TYPE 3

struct ppm * ppm_read(const char * filename) {
    FILE * fp = fopen(filename, "rb");
    if(fp == NULL) {
        warning_msg("ppm_read: Soubor '%s' nelze otevrit\n", filename);
        return NULL;
    }

    unsigned xsize, ysize;
    char color, type[TYPE];

    int read = fscanf(fp, "%s%u%u%c", type, &xsize, &ysize, &color);
    if(read != 4) {
        warning_msg("ppm_read: Soubor '%s' nelze zpracovat\n", filename);
        fclose(fp);
        return NULL;
    }

    unsigned filesize = xsize * ysize * 3;
    if(filesize > LIMIT) {
        warning_msg("ppm_read: Soubor '%s' je prilis velky\n");
        return NULL;
    }

    struct ppm * filedata = malloc(sizeof(struct ppm) + filesize);
    if(filedata == NULL) {
        warning_msg("ppm_read: Chyba alokace paměti\n");
        fclose(fp);
        return NULL;
    }

    filedata->xsize = xsize;
    filedata->ysize = ysize;

    unsigned readdata = fread(filedata->data, sizeof(char), filesize, fp);
    (void)readdata;
    fclose(fp);
    return filedata;
}

void ppm_free(struct ppm * p) {
    free(p);
}
