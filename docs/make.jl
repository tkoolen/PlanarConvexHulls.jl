push!(LOAD_PATH,"../src/")

using Documenter
using Polygon

DocMeta.setdocmeta!(Polygon, :DocTestSetup, :(using Polygon); recursive=true)

makedocs(;
    modules=[Polygon],
    checkdocs = :exports,
    root = @__DIR__,
    sitename="Polygon.jl",
    authors = "JuliaImages Team",
    pages = [
        "Home" => "index.md",
    ],
    format = Documenter.HTML(prettyurls = parse(Bool, get(ENV, "CI", "false")))
)

deploydocs(;
    repo="github.com/JuliaImages/Polygon.jl",
)