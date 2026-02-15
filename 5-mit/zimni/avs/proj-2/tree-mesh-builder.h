/**
 * @file    tree-mesh-builder.h
 *
 * @author  David Kvaček <xkvace00@stud.fit.vutbr.cz>
 *
 * @brief   Parallel Marching Cubes implementation using OpenMP tasks + octree early elimination
 *
 * @date    2025-12-08
 **/

#ifndef TREE_MESH_BUILDER_H
#define TREE_MESH_BUILDER_H

#include <vector>
#include "base-mesh-builder.h"

class TreeMeshBuilder : public BaseMeshBuilder
{
public:
    TreeMeshBuilder(unsigned gridEdgeSize);

protected:
    unsigned marchCubes(const ParametricScalarField &field);
    float evaluateFieldAt(const Vec3_t<float> &pos, const ParametricScalarField &field);
    void emitTriangle(const Triangle_t &triangle);
    const Triangle_t *getTrianglesArray() const { return mTriangles.data(); }

    unsigned processChildren(const Vec3_t<float> &offset, unsigned gridSize, const ParametricScalarField &field);

    std::vector<Triangle_t> mTriangles;
    std::vector<std::vector<Triangle_t>> mThreadTriangles;
};

#endif // TREE_MESH_BUILDER_H
