/**
 * @file    tree-mesh-builder.cpp
 *
 * @author  David Kvaček <xkvace00@stud.fit.vutbr.cz>
 *
 * @brief   Parallel Marching Cubes implementation using OpenMP tasks + octree early elimination
 *
 * @date    2025-12-08
 **/

#include <iostream>
#include <math.h>
#include <limits>
#include <omp.h>

#include "tree-mesh-builder.h"

TreeMeshBuilder::TreeMeshBuilder(unsigned gridEdgeSize)
    : BaseMeshBuilder(gridEdgeSize, "Octree")
{

}

unsigned TreeMeshBuilder::marchCubes(const ParametricScalarField &field)
{
    int maxThreads = omp_get_max_threads();
    if(mThreadTriangles.size() != size_t(maxThreads)){
        mThreadTriangles.resize(maxThreads);
    }

    for(auto& vec : mThreadTriangles) {
        vec.clear();
        vec.reserve(2048); 
    }

    unsigned totalTriangles = 0;

    #pragma omp parallel default(none) shared(field, totalTriangles, mThreadTriangles)
    {
        #pragma omp single nowait
        {
            totalTriangles = processChildren(Vec3_t<float>(0, 0, 0), mGridSize, field);
        }
    }

    mTriangles.clear();
    size_t finalCount = 0;
    for(const auto& vec : mThreadTriangles) {
        finalCount += vec.size();
    }

    mTriangles.reserve(finalCount);

    for(const auto& vec : mThreadTriangles) {
        mTriangles.insert(mTriangles.end(), vec.begin(), vec.end());
    }

    return unsigned(finalCount);
}

unsigned TreeMeshBuilder::processChildren(const Vec3_t<float> &offset, unsigned gridSize, const ParametricScalarField &field)
{
    if (gridSize <= 1) {
        return buildCube(offset, field);
    }

    Vec3_t<float> centerPos = offset;
    float halfGrid = float(gridSize) * 0.5f;
    centerPos.x += halfGrid;
    centerPos.y += halfGrid;
    centerPos.z += halfGrid;

    Vec3_t<float> physicalCenter;
    physicalCenter.x = centerPos.x * mGridResolution;
    physicalCenter.y = centerPos.y * mGridResolution;
    physicalCenter.z = centerPos.z * mGridResolution;

    float dist = evaluateFieldAt(physicalCenter, field);

    float physicalEdgeSize = float(gridSize) * mGridResolution;
    float radius = physicalEdgeSize * 0.86602540378f;   // sqrt(3)/2

    if (dist > mIsoLevel + radius) {
        return 0;
    }

    unsigned totalTriangles = 0;
    unsigned halfSize = gridSize / 2;
    bool useTasks = (gridSize > 2);

    for (int z = 0; z < 2; ++z) {
        for (int y = 0; y < 2; ++y) {
            for (int x = 0; x < 2; ++x) {
                Vec3_t<float> childOffset = offset;
                if(x == 1) childOffset.x += halfSize;
                if(y == 1) childOffset.y += halfSize;
                if(z == 1) childOffset.z += halfSize;

                unsigned sizeForChild = (x==1) ? (gridSize - halfSize) : halfSize;

                if (useTasks) {
                    #pragma omp task shared(totalTriangles, field) firstprivate(childOffset, sizeForChild)
                    {
                        unsigned t = processChildren(childOffset, sizeForChild, field);
                        #pragma omp atomic
                        totalTriangles += t;
                    }
                } else {
                    totalTriangles += processChildren(childOffset, sizeForChild, field);
                }
            }
        }
    }

    if (useTasks) {
        #pragma omp taskwait
    }

    return totalTriangles;
}

float TreeMeshBuilder::evaluateFieldAt(const Vec3_t<float> &pos, const ParametricScalarField &field)
{
    const Vec3_t<float> *pPoints = field.getPoints().data();
    const unsigned count = unsigned(field.getPoints().size());

    float value = std::numeric_limits<float>::max();

    #pragma omp simd reduction(min:value)
    for(unsigned i = 0; i < count; ++i)
    {
        float dx = pos.x - pPoints[i].x;
        float dy = pos.y - pPoints[i].y;
        float dz = pos.z - pPoints[i].z;

        float distanceSquared = dx*dx + dy*dy + dz*dz;

        if (distanceSquared < value) {
            value = distanceSquared;
        }
    }

    return sqrt(value);
}

void TreeMeshBuilder::emitTriangle(const BaseMeshBuilder::Triangle_t &triangle)
{
    int threadId = omp_get_thread_num();
    mThreadTriangles[threadId].push_back(triangle);
}
