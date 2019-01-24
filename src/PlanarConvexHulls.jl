module PlanarConvexHulls

export
    ConvexHull,
    CW,
    CCW,
    vertices,
    num_vertices,
    area,
    centroid,
    is_ordered_and_convex,
    jarvis_march!

using LinearAlgebra
using StaticArrays
using StaticArrays: arithmetic_closure

include("order.jl")
include("util.jl")
include("exceptions.jl")
include("core_types.jl")
include("area.jl")
include("convexity_test.jl")
include("centroid.jl")
include("point_in_hull.jl")
include("jarvis_march.jl")

end # module
