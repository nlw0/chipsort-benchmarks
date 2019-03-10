using BenchmarkTools
using SIMD
using ChipSort

function chipsort_merge_2_chunks(data::Array{T, 1}, ::Val{N}) where {T, N}
    Nchunks = 2
    chunk_size = div(length(data), Nchunks)

    output2 = valloc(T, div(32, sizeof(T)), length(data))

    p1 = 1
    p2 = 1 + chunk_size
    h1 = vload(Vec{N, T}, data, p1)
    h2 = vload(Vec{N, T}, data, p2)

    pout = 1
    out, state = bitonic_merge(h1, h2)

    vstorent(out, output2, pout)
    pout+=N

    end1 = chunk_size+1
    end2 = chunk_size*2+1
    p1 += N
    p2 += N
    h1 = vload(Vec{N, T}, data, p1)
    h2 = vload(Vec{N, T}, data, p2)
    while p1 < end1 || p2 < end2
        if p2 >= end2 || ((p1 < end1) && (h1[1] < h2[1]))
            out, state = bitonic_merge(state, h1)
            if p1 < end1
                p1 += N
                h1 = vload(Vec{N, T}, data, p1)
            end
        else
            out, state = bitonic_merge(state, h2)
            if p2 < end2
                p2 += N
                h2 = vload(Vec{N, T}, data, p2)
            end
        end
        vstorent(out, output2, pout)
        pout+=N
    end
    vstorent(state, output2, pout)
    output2
end

function mytest(data)
    chipsort_merge_2_chunks(data, Val(64))
end


# chnk 2^10
# 1 7.727 μs
# 2  7.742 μs
# 4 1.897 μs
# 8 2.232 μs
# 16 1.696 μs
# 32 1.597 μs
# 64 1.565 μs
# 128 2.210 μs
# 256 2.838 μs
# 512 2.978 μs

# chnk = 2^14
# 1 183.256 μs
# 2 138.548 μs
# 4 43.317 μs
# 8 32.162 μs
# 16 23.500 μs
# 32 22.109 μs
# 64 21.862 μs
# 128 30.831 μs
# 256 46.909 μs
# 512 56.003 μs

T = Int32
chunk = 2^14
data = rand(T,chunk  * 2)
data[1:chunk] .= sort(data[1:chunk])
data[1+chunk:end] .= sort(data[1+chunk:end])

mytest(data)

using ProfileView
using Profile
Profile.clear()
@profile mytest(data)
ProfileView.view()

# li, lidict = Profile.retrieve()
# using JLD
# @save "/tmp/foo.jlprof" li lidict
