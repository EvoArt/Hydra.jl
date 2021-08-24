using Hydra
using Documenter

DocMeta.setdocmeta!(Hydra, :DocTestSetup, :(using Hydra); recursive=true)

makedocs(;
    modules=[Hydra],
    authors="Arthur Newbury",
    repo="https://github.com/EvoArt/Hydra.jl/blob/{commit}{path}#{line}",
    sitename="Hydra.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://EvoArt.github.io/Hydra.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/EvoArt/Hydra.jl",
)
