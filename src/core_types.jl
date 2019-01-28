const PointLike{T} = StaticVector{2, T}

"""
$(TYPEDEF)

Represents the convex hull of a set of 2D points by its extreme points (vertices),
which are stored according to the [`VertexOrder`](@ref) given by the first type parameter.
"""
struct ConvexHull{O<:VertexOrder, T, P<:PointLike{T}, V<:AbstractVector{P}}
    vertices::V

    # TODO: use constructor to compute convex hull?
    """
    $(SIGNATURES)

    Create a new `ConvexHull` with [`VertexOrder`](@ref) `O` from the given vector of vertices.

    The `check` keyword argument (default: `true`) can be used to control whether to check
    that the provided vertices are actually in the given order.
    """
    function ConvexHull{O}(vertices::V; check=true) where {O<:VertexOrder, T, P<:PointLike{T}, V<:AbstractVector{P}}
        if check
            is_ordered_and_strongly_convex(vertices, O) || throw(OrderedStronglyConvexError())
        end
        new{O, T, P, V}(vertices)
    end
end

"""
$(SIGNATURES)

Create a new `ConvexHull` with order `O` and element type `T`, with an empty
`Vector{SVector{2, T}}` as the list of vertices.
"""
ConvexHull{O, T}() where {O<:VertexOrder, T} = ConvexHull{O}(SVector{2, T}[], check=false)

Base.eltype(::Type{<:ConvexHull{<:Any, T}}) where {T} = T

vertex_order(::Type{<:ConvexHull{O}}) where {O} = O
vertex_order(hull::ConvexHull) = vertex_order(typeof(hull))

edge_normal_sign_operator(hull::ConvexHull) = edge_normal_sign_operator(vertex_order(hull))
orientation_comparator(hull::ConvexHull) = orientation_comparator(vertex_order(hull))

"""
$(SIGNATURES)

Return the `ConvexHull`'s (ordered) vector of vertices.
"""
vertices(hull::ConvexHull) = hull.vertices

"""
$(SIGNATURES)

Return the number of vertices of the given `ConvexHull`.
"""
num_vertices(hull::ConvexHull) = length(vertices(hull))

Base.isempty(hull::ConvexHull) = num_vertices(hull) > 0
Base.empty!(hull::ConvexHull) = (empty!(hull.vertices); hull)
Base.sizehint!(hull::ConvexHull, n) = (sizehint!(hull.vertices, n); hull)
