using SIMD
using BenchmarkTools
using Formatting

using Revise
using ChipSort


function do_benchmark(T, K)

    suite = BenchmarkGroup()
    suite["Jules"] = @benchmarkable sort!(data) setup=(data = randa($T, $K))
    suite["CombSIMD"] = @benchmarkable chipsort_medium!(data, Val(8), Val(8)) setup=(data = randa($T, $K))
    suite["Comb"] = @benchmarkable combsort!(data) setup=(data = randa($T, $K))
    suite["Insrt"] = @benchmarkable insertion_sort!(data) setup=(data = randa($T, $K))

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

T=Int32;K=2^12
# T=Int8;K=2^8

# data = randa(T, K)
# display(reshape(data, 4, :))
# display(reshape(data, 8, :))
# srt = sort(data)
# display(reshape(srt, 8, :))
# @code_native debuginfo=:none chipsort_medium!(data, K, Val(64))
# chipsort_medium!(data, Val(8), Val(16))
# combsort!(data)
# display(reshape(data, 8, :))


# @btime sort_vecs!(data, Val(8), Val(8))

do_benchmark(T, K)
""
# @assert data==srt
