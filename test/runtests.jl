module PlanarConvexHullsTest

using StaticArrays
using LinearAlgebra

abstract type VertexOrder end
orientation_comparator(o::VertexOrder) = orientation_comparator(typeof(o))

struct CCW <: VertexOrder end
orientation_comparator(::Type{CCW}) = >

unpack(v::StaticVector{2}) = @inbounds return v[1], v[2]

@inline function cross2(v1::StaticVector{2}, v2::StaticVector{2})
    x1, y1 = v1[1], v1[2]
    x2, y2 = v2[1], v2[2]
    x1 * y2 - x2 * y1
end

struct ConvexHull{O<:VertexOrder, T, P<:StaticVector{2, T}, V<:AbstractVector{P}}
    vertices::V

    function ConvexHull{O}(vertices::V; check=true) where {O<:VertexOrder, T, P<:StaticVector{2, T}, V<:AbstractVector{P}}
        new{O, T, P, V}(vertices)
    end
end

ConvexHull{O, T}() where {O<:VertexOrder, T} = ConvexHull{O}(SVector{2, T}[], check=false)
vertex_order(::Type{<:ConvexHull{O}}) where {O} = O
vertex_order(hull::ConvexHull) = vertex_order(typeof(hull))
orientation_comparator(hull::ConvexHull) = orientation_comparator(vertex_order(hull))

function jarvis_march!(hull::ConvexHull, points::AbstractVector{<:StaticVector{2}})
    # Adapted from https://www.algorithm-archive.org/contents/jarvis_march/jarvis_march.html.
    op = orientation_comparator(hull)
    # @show op # Uncommenting this makes tests pass with code coverage on!
    n = length(points)
    vertices = hull.vertices
    if n <= 2
        error()
    else
        # Preallocate
        resize!(vertices, n)

        # Find an initial hull vertex using lexicographic ordering.
        start = last(points)
        for i in Base.OneTo(n - 1)
            p = points[i]
            if Tuple(p) < Tuple(start)
                start = p
            end
        end

        i = 1
        current = start
        while true
            # Add point
            vertices[i] = current

            # Next point is the one with extremal internal angle.
            next = last(points)
            δnext = next - current
            for i in Base.OneTo(n - 1)
                p = points[i]
                δ = p - current
                c = cross2(δnext, δ)

                # Note the last clause here, which ensures strong convexity in the presence of
                # collinear points by accepting `p` if it's farther away from `current` than
                # `next`.
                if next == current || op(0, c) || (c == 0 && δ ⋅ δ > δnext ⋅ δnext)
                    next = p
                    δnext = δ
                end
            end
            current = next
            current == first(vertices) && break
            i += 1
            if i > n
                error("Should never happen")
            end
        end

        # Shrink to computed number of vertices.
        resize!(vertices, i)
    end
    return hull
end

hull = ConvexHull{CCW, Float64}()
points = StaticArrays.SArray{Tuple{2},Float64,1,2}[[0.0271377, 0.785383], [0.689278, 0.242258], [0.711323, 0.403459]]
jarvis_march!(hull, points)

end # module
