module ConvexHulls2D

export
    ConvexHull2D,
    vertices,
    num_vertices,
    area,
    centroid,
    is_ccw_and_strongly_convex,
    jarvis_march!

using LinearAlgebra
using StaticArrays
using StaticArrays: arithmetic_closure

const PointLike{T} = StaticVector{2, T}

unpack(v::PointLike) = @inbounds return v[1], v[2]

@inline function cross2(v1::StaticVector{2}, v2::StaticVector{2}) # inlining this breaks things somehow!!!!!!!!!
    x1, y1 = unpack(v1)
    x2, y2 = unpack(v2)
    x1 * y2 - x2 * y1
end

struct CCWStronglyConvexError <: Exception
end
function Base.showerror(io::IO, e::CCWStronglyConvexError)
    print(io, "Points are not in counterclockwise order or do not represent a strongly convex set")
end

struct ConvexHull2D{T, P<:PointLike{T}, V<:AbstractVector{P}}
    vertices::V

    function ConvexHull2D(vertices::V; check=true) where {T, P<:PointLike{T}, V<:AbstractVector{P}}
        if check
            is_ccw_and_strongly_convex(vertices) || throw(CCWStronglyConvexError())
        end
        new{T, P, V}(vertices)
    end
end

ConvexHull2D{T}() where {T} = ConvexHull2D(SVector{2, T}[])

vertices(hull::ConvexHull2D) = hull.vertices
num_vertices(hull::ConvexHull2D) = length(vertices(hull))
Base.isempty(hull::ConvexHull2D) = num_vertices(hull) > 0
Base.empty!(hull::ConvexHull2D) = (empty!(hull.vertices); hull)

function area(hull::ConvexHull2D{T}) where T
    # https://en.wikipedia.org/wiki/Shoelace_formula
    vertices = hull.vertices
    n = length(vertices)
    n <= 2 && return zero(arithmetic_closure(T))
    @inbounds begin
        ret = cross2(vertices[n], vertices[1])
        @simd for i in Base.OneTo(n - 1)
            ret += cross2(vertices[i], vertices[i + 1])
        end
        return abs(ret) / 2
    end
end

function is_ordered_and_convex(vertices::AbstractVector{<:PointLike}, op::O) where {T, O}
    n = length(vertices)
    n <= 2 && return true
    @inbounds begin
        δprev = vertices[n] - vertices[n - 1]
        δnext = vertices[1] - vertices[n]
        for i in Base.OneTo(n - 1)
            op(cross2(δprev, δnext), 0) || return false
            δprev = δnext
            δnext = vertices[i + 1] - vertices[i]
        end
        return op(cross2(δprev, δnext), 0)
    end
end

is_ccw_and_strongly_convex(vertices::AbstractVector{<:PointLike}) = is_ordered_and_convex(vertices, >)

function Base.in(point::PointLike, hull::ConvexHull2D)
    vertices = hull.vertices
    n = length(vertices)
    @inbounds begin
        if n === 1
            return point == hull.vertices[1]
        elseif n === 2
            p′ = point - vertices[1]
            δ = vertices[2] - vertices[1]
            cross2(p′, δ) == 0 && 0 <= p′ ⋅ δ <= sum(x -> x^2, δ)
        else
            op = <= # may want to put this in a ConvexHull2D type parameter
            δ = vertices[1] - vertices[n]
            for i in Base.OneTo(n - 1)
                op(cross2(point - vertices[i], δ), 0) || return false
                δ = vertices[i + 1] - vertices[i]
            end
            return op(cross2(point - vertices[n], δ), 0)
        end
    end
end

function centroid(hull::ConvexHull2D{T}) where T
    # https://en.wikipedia.org/wiki/Centroid#Of_a_polygon
    vertices = hull.vertices
    n = length(vertices)
    R = arithmetic_closure(T)
    @inbounds begin
        if n == 1
            return R.(vertices[1])
        elseif n == 2
            return (vertices[1] + vertices[2]) / 2
        else
            c = cross2(vertices[n], vertices[1])
            centroid = (vertices[n] + vertices[1]) * c
            double_area = c
            @simd for i in Base.OneTo(n - 1)
                c = cross2(vertices[i], vertices[i + 1])
                centroid += (vertices[i] + vertices[i + 1]) * c
                double_area += c
            end
            centroid /= 3 * double_area
            return centroid
        end
    end
end

function jarvis_march!(hull::ConvexHull2D{T}, points::AbstractVector{<:PointLike{T}}) where T
    # Adapted from https://www.algorithm-archive.org/contents/jarvis_march/jarvis_march.html.
    n = length(points)
    vertices = hull.vertices
    @inbounds begin
        if n <= 2
            resize!(vertices, n)
            vertices .= points
        else
            # Preallocate
            resize!(vertices, n)

            # Initialize with leftmost point
            start = last(points)
            @simd for i in Base.OneTo(n - 1)
                p = points[i]
                start = ifelse(p[1] < start[1], p, start)
            end
            i = 1
            current = start
            while true
                # Add point
                vertices[i] = current

                # Next point is the one with with largest internal angle
                next = last(points)
                δnext = next - current
                for i in Base.OneTo(n - 1)
                    p = points[i]
                    δ = p - current
                    c = cross2(δnext, δ)
                    if next == current || c < 0 || (c == 0 && δ ⋅ δ > δnext ⋅ δnext)
                        next = p
                        δnext = δ
                    end
                end
                current = next
                current == first(vertices) && break
                i += 1
            end

            # Shrink to computed number of vertices
            resize!(vertices, i)
        end
    end
    return hull
end

end # module
