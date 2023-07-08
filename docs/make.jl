push!(LOAD_PATH,"../src/")

using Documenter
using PlanarConvexHulls

DocMeta.setdocmeta!(PlanarConvexHulls, :DocTestSetup, :(using PlanarConvexHulls); recursive=true)

makedocs(;
    modules=[PlanarConvexHulls],
    checkdocs = :exports,
    root = @__DIR__,
    sitename="PlanarConvexHulls.jl",
    authors = "Twan Koolen and contributors.",
    pages = [
        "Home" => "index.md",
    ],
    format = Documenter.HTML(prettyurls = parse(Bool, get(ENV, "CI", "false")))
)

deploydocs(;
    repo="github.com/JuliaImages/PlanarConvexHulls.jl",
)