module Hydra

using Random, LinearAlgebra, Distances, NamedArrays, StatsModels,Statistics
include("hydra2.jl")

export hydra2, 
    permute, 
    Euclidean,
    SqEuclidean,
    PeriodicEuclidean,
    Cityblock,
    TotalVariation,
    Chebyshev,
    Minkowski,
    Jaccard,
    BrayCurtis,
    RogersTanimoto,
    @formula


end
