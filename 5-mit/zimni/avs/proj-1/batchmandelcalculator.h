/**
 * @file batchmandelcalculator.h
 * @author David Kvaček <xkvace00@stud.fit.vutbr.cz>
 * @brief Implementation of Mandelbrot calculator that uses SIMD paralelization over small batches
 * @date 2025-11-07
 */

#ifndef BATCHMANDELCALCULATOR_H
#define BATCHMANDELCALCULATOR_H

#include <basemandelcalculator.h>

class BatchMandelCalculator : public BaseMandelCalculator
{
public:
    BatchMandelCalculator(unsigned matrixBaseSize, unsigned limit);
    ~BatchMandelCalculator();
    int * calculateMandelbrot();

private:
    static constexpr int BATCH_SIZE = 16;
    int *data;
    float *xvals;
    float *zReal;
    float *zImag;
    int *iters;
    unsigned w;
};

#endif
