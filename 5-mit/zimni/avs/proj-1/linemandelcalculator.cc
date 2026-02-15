/**
 * @file linemandelcalculator.cc
 * @author David Kvaček <xkvace00@stud.fit.vutbr.cz>
 * @brief Implementation of Mandelbrot calculator that uses SIMD paralelization over lines
 * @date 2025-11-07
 */

#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

#include <stdlib.h>

#include "linemandelcalculator.h"

LineMandelCalculator::LineMandelCalculator (unsigned matrixBaseSize, unsigned limit) :
    BaseMandelCalculator(matrixBaseSize, limit, "LineMandelCalculator")
{
    w = width;
    data = (int *) aligned_alloc(64, (size_t)height * (size_t)width * sizeof(int));
    xvals = (float *) aligned_alloc(64, (size_t)width * sizeof(float));
    zReal = (float *) aligned_alloc(64, (size_t)width * sizeof(float));
    zImag = (float *) aligned_alloc(64, (size_t)width * sizeof(float));
    iters = (int *) aligned_alloc(64, (size_t)width * sizeof(int));

    if (!data || !xvals || !zReal || !zImag || !iters) {
        throw std::bad_alloc();
    }

    #pragma omp simd aligned(xvals:64)
    for (unsigned i = 0; i < w; ++i) {
        xvals[i] = x_start + i * dx;
    }
}

LineMandelCalculator::~LineMandelCalculator() {
    free(data);
    free(xvals);
    free(zReal);
    free(zImag);
    free(iters);
}


int * LineMandelCalculator::calculateMandelbrot () {
    int *pdata = data;
    int halfHeight = height / 2;
    for (int i = 0; i < halfHeight; ++i) {
        float y = y_start + i * dy;
        int top = i * w;
        int bottom = (height - 1 - i) * w;

        #pragma omp simd aligned(zReal, zImag, iters, xvals:64) simdlen(16)
        for (int j = 0; j < (int)w; ++j) {
            zReal[j] = xvals[j];
            zImag[j] = y;
            iters[j] = 0;
        }

        int active = w;
        for (int iter = 0; iter < limit && active > 0; ++iter) {
            active = 0;

            #pragma omp simd aligned(zReal, zImag, iters, xvals:64) reduction(+:active) simdlen(16)
            for (int j = 0; j < (int)w; ++j) {
                float zr = zReal[j];
                float zi = zImag[j];
                float r2 = zr * zr;
                float i2 = zi * zi;

                if (r2 + i2 <= 4.0f) {
                    float newZi = 2.0f * zr * zi + y;
                    float newZr = r2 - i2 + xvals[j];
                    zReal[j] = newZr;
                    zImag[j] = newZi;
                    iters[j]++;
                    active++;
                }
            }
        }

        std::copy(iters, iters + w, data + top);
        std::copy(iters, iters + w, data + bottom);
    }

    return pdata;
}
