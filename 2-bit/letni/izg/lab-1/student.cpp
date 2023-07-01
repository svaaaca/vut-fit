/**
 * IZG - Zaklady pocitacove grafiky - FIT VUT
 * Lab 01 - Redukce barevneho prostoru
 *
 * Copyright (c) 2022-23 by Michal Vlnas, ivlnas@fit.vutbr.cz
 *
 * Tato sablona slouzi vyhradne pro studijni ucely, sireni kodu je bez vedomi autora zakazano.
 */

#include "base.h"

/**
 * Converts image into grayscale.
 * Use empiric equation presented in lecture.
 */
void ImageTransform::grayscale()
{
    // TODO: write code here
    for (uint32_t x = 0; x < cfg->width; x++) {
        for (uint32_t y = 0; y < cfg->height; y++) {
            RGB value = getPixel(x, y);
            uint8_t grey = 0.299 * value.r + 0.587 * value.g + 0.114 * value.b;
            value.r = grey;
            value.g = grey;
            value.b = grey;
            setPixel(x, y, value);
        }
    }
}

/**
 * Evaluate threshold value for further usage in thresholding,
 * has to be called after grayscale().
 *
 * Note: evaluation method will DIFFER for each group!
 *
 * @return threshold
 */
uint8_t ImageTransform::evaluateThreshold()
{
    uint8_t th = 128;

    // TODO: write code here or in evaluateThreshold(x, y)

    IZG_INFO("Evaluated threshold: " + std::to_string(th));
    return th;
}

/**
 * Evaluate threshold value for further usage in thresholding,
 * has to be called after grayscale().
 *
 * Note: evaluation method will DIFFER for each group!
 *
 * @param x Input pixel coordinate
 * @param y Input pixel coordinate
 * @return  threshold
 */
uint8_t ImageTransform::evaluateThreshold(int32_t x, int32_t y)
{
    (void)x;
    (void)y;

    uint8_t th = 128;

    // TODO: write code here or in evaluateThreshold()

    return th;
}

void ImageTransform::threshold()
{
    // TODO: write code here
}

void ImageTransform::randomDithering()
{
    grayscale();

    for (uint32_t y = 0; y < cfg->h; y++)
    {
        for (uint32_t x = 0; x < cfg->w; x++)
        {
            auto p = getPixel(x, y);
            uint8_t value = p.r > getRandom() ? 255 : 0;

            setPixel(x, y, RGB(value));
        }
    }
}

void ImageTransform::orderedDithering()
{
    static uint8_t matrix[m_side][m_side] =
    {
        { 0,   254, 51,  255 },
        { 68,  136, 187, 119 },
        { 34,  238, 17,  221 },
        { 170, 102, 153, 85  }
    };

    // TODO: write code here
}

void ImageTransform::updatePixelWithError(uint32_t x, uint32_t y, float err)
{
    (void)x;
    (void)y;
    (void)err;

    // TODO: write code here
}

void ImageTransform::errorDistribution()
{
    // TODO: write code here
}

