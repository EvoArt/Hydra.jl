using Hydra, DataFrames
using Test

@testset "Hydra.jl" begin
    # Write your tests here.
    x = rand(1:4,100)
y = randn(100,5) .+ (x .* (x .==3))
D = pairwise(BrayCurtis(),y',y')
preds = [[:a,:b,:c,:d][i] for i in x]
df = DataFrame([preds],[:x])
Hyde = hydra2(df,D,@formula(1~x))
Hyde = hydra2(df,D,@formula(1~x),true)
permute(Hyde,1000)

end
