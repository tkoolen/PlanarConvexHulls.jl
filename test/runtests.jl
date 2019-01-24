module ConvexHulls2DTest

using ConvexHulls2D
using StaticArrays
using Test
using Random
using LinearAlgebra
using Statistics

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
        linesegment = ConvexHull2D([p1, p2])
        @test p1 ∈ linesegment
        @test p2 ∈ linesegment
        @test div.(p1 + p2, 2) ∈ linesegment
        @test p1 + 2 * (p2 - p1) ∉ linesegment
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

    @testset "rectangle" begin
        rng = MersenneTwister(1)
        width = 4
        height = 3
        origin = Point(2, 4)
        rectangle = ConvexHull2D(map(x -> x + origin, SVector(Point(0, 0), Point(width, 0), SVector(width, height), SVector(0, height))))
        for p in vertices(rectangle)
            @test p ∈ rectangle
        end
        for i = 1 : 100_000
            p = origin + SVector(width * rand(rng), height * rand(rng))
            @test p ∈ rectangle
        end
        for i = 1 : 10
            p = origin + SVector(width * rand(rng), height * rand(rng))
            @test setindex(p, origin[1] + width + rand(rng), 1) ∉ rectangle
            @test setindex(p, origin[1] - rand(rng), 1) ∉ rectangle
            @test setindex(p, origin[2] + height + rand(rng), 2) ∉ rectangle
            @test setindex(p, origin[2] - rand(rng), 2) ∉ rectangle
        end
    end
end

@testset "centroid" begin
    @testset "point" begin
        p = Point(1, 2)
        @test centroid(ConvexHull2D([p])) === Float64.(p)
    end

    @testset "line segment" begin
        p1 = SVector(1, 1)
        p2 = SVector(3, 5)
        linesegment = ConvexHull2D([p1, p2])
        @test centroid(linesegment) == Point(2.0, 3.0)
    end

    @testset "triangle" begin
        triangle = ConvexHull2D(SVector(Point(1, 1), Point(2, 1), Point(3, 3)))
        @test centroid(triangle) ≈ mean(vertices(triangle)) atol=1e-15
    end
end

@testset "jarvis_march!" begin
    hull = ConvexHull2D{Float64}()
    rng = MersenneTwister(2)
    for n = 1 : 10
        for _ = 1 : 10_000
            points = [rand(rng, Point{Float64}) for i = 1 : n]
            jarvis_march!(hull, points)
            @test is_ccw_and_strongly_convex(vertices(hull))
        end
    end
end

end # module
