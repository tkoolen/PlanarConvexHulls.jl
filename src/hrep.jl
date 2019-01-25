"""
Return the equivalent halfspace representation of the convex hull, i.e.
matrix ``A`` and vector ``b`` such that the set of points inside the hull
is

```math
\\left\\{ x \\mid A x \\le b \\right\\}
```
"""
hrep(hull::ConvexHull) = _hrep(hull, Length(vertices(hull)))

function _hrep(hull::ConvexHull, ::Length{N}) where N
    T = eltype(hull)
    R = arithmetic_closure(T)
    vertices = hull.vertices
    if N === StaticArrays.Dynamic()
        n = length(vertices)
        A = similar(vertices, R, n, 2)
        b = similar(vertices, R, n)
        hrep!(A, b, hull)
        return A, b
    else
        Amut = similar(vertices, R, Size(N, 2))
        bmut = similar(vertices, R, Size(N))
        hrep!(Amut, bmut, hull)
        A = convert(similar_type(vertices, R, Size(Amut)), Amut)
        b = convert(similar_type(vertices, R, Size(bmut)), bmut)
        return A, b
    end
end

@inline function hrep!(A::AbstractMatrix, b::AbstractVector, hull::ConvexHull)
    signop = edge_normal_sign_operator(hull)
    vertices = hull.vertices
    n = length(vertices)
    @boundscheck begin
        size(A) == (n, 2) || throw(DimensionMismatch())
        length(b) == n || throw(DimensionMismatch())
    end
    @inbounds @simd ivdep for i = Base.OneTo(n)
        Ai, bi = hrep_kernel(vertices, signop, i)
        A[i, 1] = Ai[1]
        A[i, 2] = Ai[2]
        b[i] = bi
    end
end

Base.@propagate_inbounds function hrep_kernel(vertices, signop, i)
    n = length(vertices)
    v1 = vertices[i]
    v2 = vertices[ifelse(i == n, 1, i + 1)]
    δ = v2 - v1
    δx, δy = unpack(δ)
    outward_normal = signop(SVector(δy, -δx))
    Ai = transpose(outward_normal)
    bi = Ai * v1
    Ai, bi
end
