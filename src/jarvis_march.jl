function jarvis_march!(hull::ConvexHull, points::AbstractVector{<:PointLike})
    # Adapted from https://www.algorithm-archive.org/contents/jarvis_march/jarvis_march.html.
    op = orientation_comparator(hull)
    n = length(points)
    vertices = hull.vertices
    @inbounds begin
        if n <= 2
            resize!(vertices, n)
            vertices .= points
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
            end

            # Shrink to computed number of vertices.
            resize!(vertices, i)
        end
    end
    return hull
end
