using SIMD
using BenchmarkTools
using Formatting

using Revise
using ChipSort


function do_benchmark(T, K)
    V=8
    J=8
    len = V*J*K
    suite = BenchmarkGroup()
    suite["Jules"] = @benchmarkable sort!(data) setup=(data = randa($T, $len))
    suite["CombSIMD"] = @benchmarkable chipsort_medium!(data, Val(V), Val(J), Val(K)) setup=(data = randa($T, $len))
    suite["Comb"] = @benchmarkable combsort!(data) setup=(data = randa($T, $len))
    suite["Insrt"] = @benchmarkable insertion_sort!(data) setup=(data = randa($T, $len))

    res=run(suite)
    for l in ["Insrt", "Jules", "Comb", "CombSIMD"]
        printfmtln("{:>8s} {}", l, repr(res[l]))
    end
    res
end

function randa(T, K)
    data = valloc(T, div(32, sizeof(T)), K)
    data .= rand(T, K)
    data
end

T=Int32;K=2^7
# T=Int8;K=4
V=8
J=8


len = V*J*K

# data = randa(T, len)
# display(reshape(data, V, :))
# display(reshape(data, 8, :))
# srt = sort(data)
# display(reshape(srt, 8, :))
# @code_native debuginfo=:none chipsort_medium!(data, K, Val(64))
# chipsort_medium!(data, Val(V), Val(J), Val(K))
# combsort!(data)
# display(reshape(data, 8, :))


# @btime sort_vecs!(data, Val(8), Val(8))

do_benchmark(T, K)
""
# @assert data==srt
