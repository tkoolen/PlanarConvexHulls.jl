module ConvexHulls2DTest

using ConvexHulls2D
using StaticArrays
using Test
using Random
using LinearAlgebra

const Point{T} = SVector{2, T}

@testset "is_ccw_and_strongly_convex" begin
    @test is_ccw_and_strongly_convex([Point(1, 2)])
    @test is_ccw_and_strongly_convex([Point(1, 2), Point(3, 4)])
    @test is_ccw_and_strongly_convex([Point(1, 2), Point(3, 4), Point(2, 4)])
    @test !is_ccw_and_strongly_convex([Point(1, 2), Point(3, 4), Point(2, 3)]) # on a line

    v1 = Point(0, 0)
    v2 = Point(1, 0)
    v3 = Point(1, 1)
    v4 = Point(0, 1)
    vertices = [v1, v2, v3, v4]
    for i in 0 : 4
        shifted = circshift(vertices, i)
        @test is_ccw_and_strongly_convex(shifted)
        @test !is_ccw_and_strongly_convex(reverse(shifted))
    end

    for i in eachindex(vertices)
        for j in eachindex(vertices)
            if i != j
                vertices′ = copy(vertices)
                vertices′[i] = vertices[j]
                vertices′[j] = vertices[i]
                @test !is_ccw_and_strongly_convex(vertices′)
            end
        end
    end
end

@testset "area" begin
    @test area(ConvexHull2D(SVector((SVector(1, 1),)))) == 0

    @test area(ConvexHull2D(SVector(SVector(1, 1), SVector(2, 3)))) == 0

    triangle = ConvexHull2D(SVector(Point(1, 1), Point(2, 1), Point(3, 3)))
    @test area(triangle) == 1.0

    square = ConvexHull2D(SVector(Point(1, 1), Point(4, 1), Point(4, 3), Point(1, 3)))
    @test area(square) == 3 * 2
end

@testset "in" begin
    @testset "point" begin
        rng = MersenneTwister(1)
        p = SVector(1, 1)
        C = ConvexHull2D(SVector((p,)))
        @test p ∈ C
        @test Float64.(p) ∈ C
        for i in 1 : 10
            @test p + SVector(randn(rng), randn(rng)) ∉ C
        end
    end

    @testset "line segment" begin
        p1 = SVector(1, 1)
        p2 = SVector(3, 5)
        C = ConvexHull2D([p1, p2])
        @test p1 ∈ C
        @test p2 ∈ C
        @test div.(p1 + p2, 2) ∈ C
        @test p1 + 2 * (p2 - p1) ∉ C
    end

    @testset "triangle" begin
        rng = MersenneTwister(1)
        triangle = ConvexHull2D(SVector(Point(1, 1), Point(2, 1), Point(3, 3)))
        for p in vertices(triangle)
            @test p ∈ triangle
        end
        for i = 1 : 100_000
            weights = normalize(rand(rng, SVector{3}), 1)
            p = reduce(+, vertices(triangle) .* weights)
            @test p ∈ triangle
        end
    end
end

end # module
