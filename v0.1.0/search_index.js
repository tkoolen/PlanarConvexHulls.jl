var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#PlanarConvexHulls.jl-1",
    "page": "Home",
    "title": "PlanarConvexHulls.jl",
    "category": "section",
    "text": "PlanarConvexHulls provides a ConvexHull type, which represents the convex hull of a set of 2D points by its extreme points. Functionality includes:convexity test\nconstruction of a convex hull given a set of points\narea\ncentroid\npoint-in-convex-hull test\nclosest point within convex hull\nequivalent halfspace representation of the convex hull"
},

{
    "location": "#Types-1",
    "page": "Home",
    "title": "Types",
    "category": "section",
    "text": ""
},

{
    "location": "#PlanarConvexHulls.ConvexHull",
    "page": "Home",
    "title": "PlanarConvexHulls.ConvexHull",
    "category": "type",
    "text": "struct ConvexHull{O<:PlanarConvexHulls.VertexOrder, T, P<:StaticArrays.StaticArray{Tuple{2},T,1}, V<:AbstractArray{P<:StaticArrays.StaticArray{Tuple{2},T,1},1}}\n\nRepresents the convex hull of a set of 2D points by its extreme points (vertices), which are stored according to the VertexOrder given by the first type parameter.\n\n\n\n\n\n"
},

{
    "location": "#PlanarConvexHulls.vertices",
    "page": "Home",
    "title": "PlanarConvexHulls.vertices",
    "category": "function",
    "text": "vertices(hull)\n\n\nReturn the ConvexHull\'s (ordered) vector of vertices.\n\n\n\n\n\n"
},

{
    "location": "#PlanarConvexHulls.num_vertices",
    "page": "Home",
    "title": "PlanarConvexHulls.num_vertices",
    "category": "function",
    "text": "num_vertices(hull)\n\n\nReturn the number of vertices of the given ConvexHull.\n\n\n\n\n\n"
},

{
    "location": "#The-ConvexHull-type-1",
    "page": "Home",
    "title": "The ConvexHull type",
    "category": "section",
    "text": "ConvexHull\nvertices\nnum_vertices"
},

{
    "location": "#PlanarConvexHulls.VertexOrder",
    "page": "Home",
    "title": "PlanarConvexHulls.VertexOrder",
    "category": "type",
    "text": "abstract type VertexOrder\n\nA VertexOrder represents the order in which the vertices of a ConvexHull are stored.\n\n\n\n\n\n"
},

{
    "location": "#PlanarConvexHulls.CCW",
    "page": "Home",
    "title": "PlanarConvexHulls.CCW",
    "category": "type",
    "text": "struct CCW <: PlanarConvexHulls.VertexOrder\n\nCounterclockwise vertex order.\n\n\n\n\n\n"
},

{
    "location": "#PlanarConvexHulls.CW",
    "page": "Home",
    "title": "PlanarConvexHulls.CW",
    "category": "type",
    "text": "struct CW <: PlanarConvexHulls.VertexOrder\n\nClockwise vertex order.\n\n\n\n\n\n"
},

{
    "location": "#VertexOrders-1",
    "page": "Home",
    "title": "VertexOrders",
    "category": "section",
    "text": "PlanarConvexHulls.VertexOrder\nCCW\nCW"
},

{
    "location": "#PlanarConvexHulls.is_ordered_and_strongly_convex",
    "page": "Home",
    "title": "PlanarConvexHulls.is_ordered_and_strongly_convex",
    "category": "function",
    "text": "is_ordered_and_strongly_convex(vertices, order)\n\n\nReturn whether vertices are ordered according to vertex order type O (a subtype of VertexOrder), and as a result strongly convex (see e.g. CGAL documentation for a definition of strong convexity).\n\n\n\n\n\n"
},

{
    "location": "#PlanarConvexHulls.jarvis_march!",
    "page": "Home",
    "title": "PlanarConvexHulls.jarvis_march!",
    "category": "function",
    "text": "jarvis_march!(hull, points)\n\n\nCompute the convex hull of points and store the result in hull using the Jarvis march (gift wrapping) algorithm. This algorithm has O(nh) complexity, where n is the number of points and h is the number of vertices of the convex hull.\n\n\n\n\n\n"
},

{
    "location": "#PlanarConvexHulls.area",
    "page": "Home",
    "title": "PlanarConvexHulls.area",
    "category": "function",
    "text": "area(hull)\n\n\nCompute the area of the given ConvexHull using the shoelace formula.\n\n\n\n\n\n"
},

{
    "location": "#PlanarConvexHulls.centroid",
    "page": "Home",
    "title": "PlanarConvexHulls.centroid",
    "category": "function",
    "text": "centroid(hull)\n\n\nCompute the centroid or geometric center of the given ConvexHull using the formulas given here.\n\n\n\n\n\n"
},

{
    "location": "#Base.in-Tuple{StaticArrays.StaticArray{Tuple{2},T,1} where T,ConvexHull}",
    "page": "Home",
    "title": "Base.in",
    "category": "method",
    "text": "in(point, hull)\n\n\nReturn whether point is in hull.\n\n\n\n\n\n"
},

{
    "location": "#PlanarConvexHulls.closest_point",
    "page": "Home",
    "title": "PlanarConvexHulls.closest_point",
    "category": "function",
    "text": "closest_point(p, hull)\n\n\nFind the closest point to p within hull. If p is inside hull, p itself is returned.\n\n\n\n\n\n"
},

{
    "location": "#PlanarConvexHulls.hrep",
    "page": "Home",
    "title": "PlanarConvexHulls.hrep",
    "category": "function",
    "text": "hrep(hull)\n\n\nReturn the equivalent halfspace representation of the convex hull, i.e. matrix A and vector b such that the set of points inside the hull is\n\nleft x mid A x le b right\n\nIf hull is backed by a statically sized vector of vertices, the output (A, b) will be statically sized as well. If the vector of vertices is additionally immutable (e.g., a StaticArrays.SVector), then hrep will not perform any dynamic memory allocation.\n\n\n\n\n\n"
},

{
    "location": "#PlanarConvexHulls.hrep!",
    "page": "Home",
    "title": "PlanarConvexHulls.hrep!",
    "category": "function",
    "text": "hrep!(A, b, hull)\n\n\nReturn the equivalent halfspace representation of the convex hull, i.e. matrix A and vector b such that the set of points inside the hull is\n\nleft x mid A x le b right\n\nThis function stores its output in the (mutable) matrix A and vector b.\n\n\n\n\n\n"
},

{
    "location": "#Algorithms-1",
    "page": "Home",
    "title": "Algorithms",
    "category": "section",
    "text": "is_ordered_and_strongly_convex\njarvis_march!\narea\ncentroid\nBase.in(point::PlanarConvexHulls.PointLike, hull::ConvexHull)\nclosest_point\nhrep\nhrep!"
},

]}
