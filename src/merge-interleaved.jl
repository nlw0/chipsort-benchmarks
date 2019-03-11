using SIMD
using ChipSort

include("utils.jl")
include("bitonic-merge-network.jl")


T = Int32
N = 8

adata = [sort(rand(T,N)) for _ in 1:2^10]
using BenchmarkTools

function mytest(adata, L)
    [bitonic_merge_interleaved(
        ntuple(x->Vec((adata[(k-1)*L+x]...,)), L)
        ...)
    for k in 1:(div(256, L))]
end

xx = [
    (@benchmark mytest($adata, $L))
    for L in [2,4,6,8,10,12]
]

using Plots
pyplot()
plot(xlim=(120,180), xlabel="Time [μs]", ylabel="Trial#", title="Performance (time eCDF) from interleaved SIMD bitonic merge")
plot!(1e-3*xx[1].times, 1:10000, l=3, label="1 merge")
plot!(1e-3*xx[2].times, 1:10000, l=3, label="2 merges")
plot!(1e-3*xx[3].times, 1:10000, l=3, label="3 merges")
plot!(1e-3*xx[4].times, 1:10000, l=3, label="4 merges")
plot!(1e-3*xx[5].times, 1:10000, l=3, label="5 merges")
plot!(1e-3*xx[6].times, 1:10000, l=3, label="6 merges")
