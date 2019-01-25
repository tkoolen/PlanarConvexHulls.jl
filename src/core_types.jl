const PointLike{T} = StaticVector{2, T}

struct ConvexHull{O<:VertexOrder, T, P<:PointLike{T}, V<:AbstractVector{P}}
    vertices::V

    # TODO: use constructor to compute convex hull?
    function ConvexHull{O}(vertices::V; check=true) where {O<:VertexOrder, T, P<:PointLike{T}, V<:AbstractVector{P}}
        if check
            is_ordered_and_convex(vertices, O) || throw(OrderedStronglyConvexError())
        end
        new{O, T, P, V}(vertices)
    end
end

ConvexHull{O, T}() where {O<:VertexOrder, T} = ConvexHull{O}(SVector{2, T}[], check=false)

Base.eltype(::Type{<:ConvexHull{<:Any, T}}) where {T} = T
vertex_order(::Type{<:ConvexHull{O}}) where {O} = O
vertex_order(hull::ConvexHull) = vertex_order(typeof(hull))
edge_normal_sign_operator(hull::ConvexHull) = edge_normal_sign_operator(vertex_order(hull))

orientation_comparator(hull::ConvexHull) = orientation_comparator(vertex_order(hull))
vertices(hull::ConvexHull) = hull.vertices
num_vertices(hull::ConvexHull) = length(vertices(hull))
Base.isempty(hull::ConvexHull) = num_vertices(hull) > 0
Base.empty!(hull::ConvexHull) = (empty!(hull.vertices); hull)
Base.sizehint!(hull::ConvexHull, n) = (sizehint!(hull.vertices, n); hull)
