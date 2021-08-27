using Hydra, DataFrames,Distances
using Test

@testset "Hydra.jl" begin
    # Write your tests here.
    x = rand(1:4,100)
y = randn(100,5) .+ (x .* (x .==3))

preds = [["a","b","c","d"][i] for i in x]
df = DataFrame([preds],[:x])
Hyde = hydra2(df,y,BrayCurtis,@formula(1~x))
Hyde = hydra2(df,y,BrayCurtis,@formula(1~x),pairs =true)
permute(Hyde,df.x,1000)

end
