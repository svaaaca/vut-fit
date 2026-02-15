/**
 * @file    loop-mesh-builder.cpp
 *
 * @author  David Kvaček <xkvace00@stud.fit.vutbr.cz>
 *
 * @brief   Parallel Marching Cubes implementation using OpenMP loops
 *
 * @date    2025-12-08
 **/

#include <iostream>
#include <math.h>
#include <limits>
#include <omp.h>

#include "loop-mesh-builder.h"

LoopMeshBuilder::LoopMeshBuilder(unsigned gridEdgeSize)
    : BaseMeshBuilder(gridEdgeSize, "OpenMP Loop")
{

}

unsigned LoopMeshBuilder::marchCubes(const ParametricScalarField &field)
{
    size_t totalCubesCount = mGridSize * mGridSize * mGridSize;
    int maxThreads = omp_get_max_threads();
    mThreadTriangles.resize(maxThreads);
    for(auto& vec : mThreadTriangles) {
        vec.clear();
    }

    #pragma omp parallel default(none) shared(totalCubesCount, field, mThreadTriangles)
    {
        #pragma omp for schedule(dynamic, 32)
        for(size_t i = 0; i < totalCubesCount; ++i)
        {
            Vec3_t<float> cubeOffset(i % mGridSize, (i / mGridSize) % mGridSize, i / (mGridSize * mGridSize));
            buildCube(cubeOffset, field);
        }
    }

    mTriangles.clear();
    size_t totalTriangles = 0;
    for(const auto& vec : mThreadTriangles) {
        totalTriangles += vec.size();
    }

    mTriangles.reserve(totalTriangles);

    for(const auto& vec : mThreadTriangles) {
        mTriangles.insert(mTriangles.end(), vec.begin(), vec.end());
    }

    return unsigned(totalTriangles);
}

float LoopMeshBuilder::evaluateFieldAt(const Vec3_t<float> &pos, const ParametricScalarField &field)
{
    const Vec3_t<float> *pPoints = field.getPoints().data();
    const unsigned count = unsigned(field.getPoints().size());

    float value = std::numeric_limits<float>::max();

    for(unsigned i = 0; i < count; ++i)
    {
        float distanceSquared  = (pos.x - pPoints[i].x) * (pos.x - pPoints[i].x);
        distanceSquared       += (pos.y - pPoints[i].y) * (pos.y - pPoints[i].y);
        distanceSquared       += (pos.z - pPoints[i].z) * (pos.z - pPoints[i].z);

        value = std::min(value, distanceSquared);
    }

    return sqrt(value);
}

void LoopMeshBuilder::emitTriangle(const BaseMeshBuilder::Triangle_t &triangle)
{
    int threadId = omp_get_thread_num();
    mThreadTriangles[threadId].push_back(triangle);
}
