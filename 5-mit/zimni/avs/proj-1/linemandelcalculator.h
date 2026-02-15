/**
 * @file linemandelcalculator.h
 * @author David Kvaček <xkvace00@stud.fit.vutbr.cz>
 * @brief Implementation of Mandelbrot calculator that uses SIMD paralelization over lines
 * @date 2025-11-07
 */

#ifndef LINEMANDELCALCULATOR_H
#define LINEMANDELCALCULATOR_H

#include <basemandelcalculator.h>

class LineMandelCalculator : public BaseMandelCalculator
{
public:
    LineMandelCalculator(unsigned matrixBaseSize, unsigned limit);
    ~LineMandelCalculator();
    int *calculateMandelbrot();

private:
    int *data;
    float *xvals;
    float *zReal;
    float *zImag;
    int *iters;
    unsigned w;
};

#endif
