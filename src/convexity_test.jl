function is_ordered_and_convex(vertices::AbstractVector{<:PointLike}, ::Type{O}) where {O<:VertexOrder}
    op = orientation_comparator(O)
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
