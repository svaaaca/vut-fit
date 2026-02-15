/**
 * @file refmandelcalculator.h
 * @author Vojtech Mrazek (mrazek@fit.vutbr.cz)
 * @brief Naive implementation
 * @date 2021-09-24
 */

#ifndef REFMANDELCALCULATOR_H
#define REFMANDELCALCULATOR_H

#include <basemandelcalculator.h>

class RefMandelCalculator : public BaseMandelCalculator
{
public:
    RefMandelCalculator(unsigned matrixBaseSize, unsigned limit);
    ~RefMandelCalculator();
    int *calculateMandelbrot();

private:
    int *data;
};

#endif
