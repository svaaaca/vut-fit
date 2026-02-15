/**
 * @file batchmandelcalculator.cc
 * @author David Kvaček <xkvace00@stud.fit.vutbr.cz>
 * @brief Implementation of Mandelbrot calculator that uses SIMD paralelization over small batches
 * @date 2025-11-07
 */

#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

#include <stdlib.h>
#include <stdexcept>

#include "batchmandelcalculator.h"

BatchMandelCalculator::BatchMandelCalculator (unsigned matrixBaseSize, unsigned limit) :
    BaseMandelCalculator(matrixBaseSize, limit, "BatchMandelCalculator")
{
    w = width;
    data = (int *) aligned_alloc(64, (size_t)height * (size_t)width * sizeof(int));
    xvals = (float *) aligned_alloc(64, (size_t)width * sizeof(float));
    zReal = (float *) aligned_alloc(64, (size_t)BATCH_SIZE * sizeof(float));
    zImag = (float *) aligned_alloc(64, (size_t)BATCH_SIZE * sizeof(float));
    iters = (int *) aligned_alloc(64, (size_t)BATCH_SIZE * sizeof(int));

    if (!data || !xvals || !zReal || !zImag || !iters) {
        throw std::bad_alloc();
    }

    #pragma omp simd aligned(xvals:64)
    for (unsigned i = 0; i < w; ++i) {
        xvals[i] = x_start + i * dx;
    }
}

BatchMandelCalculator::~BatchMandelCalculator() {
    free(data);
    free(xvals);
    free(zReal);
    free(zImag);
    free(iters);
}


int * BatchMandelCalculator::calculateMandelbrot () {
    int *pdata = data;
    int halfHeight = height / 2;
    for (int i = 0; i < halfHeight; ++i) {
        float y = y_start + i * dy;
        int top = i * w;
        int bottom = (height - 1 - i) * w;

        for (int j = 0; j + BATCH_SIZE <= (int)w; j += BATCH_SIZE) {
            #pragma omp simd aligned(zReal, zImag, iters, xvals:64) simdlen(16)
            for (int k = 0; k < BATCH_SIZE; ++k) {
                zReal[k] = xvals[j + k];
                zImag[k] = y;
                iters[k] = 0;
            }

            int active = BATCH_SIZE;
            for (int iter = 0; iter < limit && active > 0; ++iter) {
                active = 0;

                #pragma omp simd aligned(zReal, zImag, iters, xvals:64) reduction(+:active) simdlen(16)
                for (int k = 0; k < BATCH_SIZE; ++k) {
                    float zr = zReal[k];
                    float zi = zImag[k];
                    float r2 = zr * zr;
                    float i2 = zi * zi;

                    if (r2 + i2 <= 4.0f) {
                        float newZi = 2.0f * zr * zi + y;
                        float newZr = r2 - i2 + xvals[j + k];
                        zReal[k] = newZr;
                        zImag[k] = newZi;
                        iters[k]++;
                        active++;
                    }
                }
            }

            std::copy(iters, iters + BATCH_SIZE, data + top + j);
            std::copy(iters, iters + BATCH_SIZE, data + bottom + j);
        }
    }

    return pdata;
}
