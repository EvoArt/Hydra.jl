
using Random, LinearAlgebra, Distances, NamedArrays
using RCall, StatsModels, DataFrames
R"library(vegan)"

struct Hydra
    F_report
    F
    G
    mod_mat
end

function dblcen(D)
    A = D .- mean(D,dims = 1)
    return A .- mean(A,dims = 2) 
end

function QRfit(x,y)
    Q, R = LinearAlgebra.qr(x)
    β = (R^(-1)*Q' *y)'
    fitted =   x * β'#sum(x .* β, dims = 2)
    residuals = y .-fitted
    return sum(fitted .^2), sum(Diagonal(residuals) .^2)
end

function QRfit(Q,R,x,y)
    β = (R^(-1)*Q' *y)'
    fitted =   x * β'#sum(x .* β, dims = 2)
    residuals = y .-fitted
    return sum(fitted .^2)/ sum(Diagonal(residuals) .^2)
end

function hydra2(data,D, formula = @formula(1~1), pairs = false)

    mod_mat = StatsModels.modelmatrix(formula,data)
    n,m = size(mod_mat)
    G = -0.5 * dblcen(D .^2)
    Gfit, Gres = QRfit(mod_mat,G)
    F_report = (Gfit/(m-1)) / (Gres/(n-m))
    F = Gfit / Gres

    if pairs == true
        pair_array = Array{Hydra}(undef,m+1,m+1)
        bool_mat = Bool.(hcat(sum(mod_mat, dims = 2) .==0, mod_mat))
        for i in 2:m+1
            for j in 1:i-1
                bool_mask = bool_mat[:,i] .| bool_mat[:,j]
                mm = float.(bool_mat[bool_mask,[i,j]])
                g = G[bool_mask,bool_mask]
                pair_array[i,j] = hydra2(g,mm)
            end
        end
        pair_array[1,m+1] = Hydra(F_report,F, G,mod_mat)
        return pair_array
    else
    return Hydra(F_report,F, G,mod_mat)
    end
end

function hydra2(G ::Matrix,mod_mat ::Matrix)
    Gfit, Gres = QRfit(mod_mat,G)
    F_report = (Gfit/(m-1)) / (Gres/(n-m))
    F = Gfit / Gres
    return Hydra(F_report,F, G,mod_mat)
end


function permute(H ::Hydra,n_perm = 1000)
    mod_mat = H.mod_mat
    G = H.G
    Q,R = qr(mod_mat)
    inds = collect(1:size(mod_mat)[1])
    F = Vector{Float64}(undef,n_perm)
     for i in 1:n_perm
       F[i] = QRfit(Q,R,mod_mat,view(G,shuffle!(inds),shuffle!(inds)))
    end
    return sum(H.F .< F) /n_perm
end

function permute(H ::Matrix{Hydra},n_perm = 1000)
    n = size(H)[1]
    P = zeros(n,n)
    println(P)

    Threads.@threads for i in 2:n
                        for j in 1:i-1
                            P[i,j] = permute(H[i,j],n_perm)
                        end
                    end
                    P[1,n] = permute(H[1,n])
    return P
end

x = rand(1:4,100)
y = randn(100,5) .+ (x .* (x .==3))
D = pairwise(BrayCurtis(),y',y')
preds = [[:a,:b,:c,:d][i] for i in x]
df = DataFrame([preds],[:x])
Hyde = hydra2(df,D,@formula(1~x))
Hyde = hydra2(df,D,@formula(1~x),true)
permute(Hyde,1000)

