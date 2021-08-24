#The key to the non-parametric method describedhere 
#is that the sum of squared distances between pointsand 
#their centroid is equal to (and can be calculateddirectly from) 
#the sum of squared interpoint distancesdivided by the number of points
# https://onlinelibrary.wiley.com/doi/epdf/10.1111/j.1442-9993.2001.01070.pp.x
SSₜ(D,N) = sum(D .^2)/N # given a triangular dist matrix
function SS_W(D,N,n)
    return  SSₜ(D,N)/n
end

function F(D,W,N,n,a)
    SST = SSₜ(D,N)
    SSW = SS_W(W,N,n)
    A = SST - SSW
    F = (A/(a-1))/(W/(N-a))
end

permutest(D,group,N,n,a, n_perm = 1000)
    N =  length(group)
    a = length(unique(group))
    n = N/a
    W_inds = [CartesianIndex(i,j) for i in 1:(N-1) for j in i+1:N if group[i] == group[j]]
    W = D[W_inds]
    notW = D[.!W_inds]
    D = vcat(W,notW)
    

    f = F(D,W,N,n,a)
    Fs = Vector{Float64}(undef,n_perm)
    inds = 1:length(W)

    for i in 1:n_perm
        shuffle!.(D)
        Fs[i] = Fknown(view(D,inds),N,n,a)
    end
    P = sum(Fs .>= f)/n_perm
    return P
end


