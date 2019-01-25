abstract type VertexOrder end
orientation_comparator(o::VertexOrder) = orientation_comparator(typeof(o))
edge_normal_sign_operator(o::VertexOrder) = orientation_comparator(typeof(o))

"""
Counterclockwise order.
"""
struct CCW <: VertexOrder end
orientation_comparator(::Type{CCW}) = >
edge_normal_sign_operator(::Type{CCW}) = +

"""
Clockwise order.
"""
struct CW <: VertexOrder end
orientation_comparator(::Type{CW}) = <
edge_normal_sign_operator(::Type{CW}) = -
