function area(hull::ConvexHull)
    # https://en.wikipedia.org/wiki/Shoelace_formula
    T = eltype(hull)
    vertices = hull.vertices
    n = length(vertices)
    n <= 2 && return zero(arithmetic_closure(T))
    @inbounds begin
        ret = cross2(vertices[n], vertices[1])
        for i in Base.OneTo(n - 1)
            ret += cross2(vertices[i], vertices[i + 1])
        end
        return abs(ret) / 2
    end
end
