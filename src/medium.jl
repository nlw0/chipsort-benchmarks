using SIMD

using BenchmarkTools

using Revise
using ChipSort


# data = rand(Int32, 2^10)
# @code_warntype merge_vecs_tree(data, Val(8), Val(8))

# data = tuple([Vec(tuple(rand(Int8, 4)...)) for _ in 1:4]...)
# @code_warntype merge_vecs_tree(data...)

# data = tuple([Vec(tuple(rand(Int8, 4)...)) for _ in 1:4]...)
# @code_warntype sort_small_array(data)

# data = rand(Int8, 16*64)
# @code_warntype merge_vecs_tree(data, Val(16), Val(8), Val(8))

# T=Int32
# V=8
# J=8
# K=64

# data = valloc(T, div(32, sizeof(T)), V*J*K)
# data .= rand(T, V*J*K)
# # data .= [1:4:32;2:4:32;3:4:32;4:4:32;]

# qq = chipsort_medium(data, Val(V), Val(J), Val(K))
# reshape(qq, 16,:)

# @assert chipsort_medium(data, Val(V), Val(J), Val(K)) == sort(data)

# @code_warntype chipsort_medium(data, Val(V), Val(J), Val(K))


function base(data)
    for d in length(data)
        sort(data[d])
    end
end

function mine(data)
    for d in length(data)
        chipsort_medium(data[d], Val(4), Val(4), Val(128))
    end
end

data = [rand(Int64, 16*128) for _ in 1:1000]

base(data) == mine(data)

display(@benchmark base($data))
display(@benchmark mine($data))


# using Profile
# using ProfileView
# Profile.clear()
# @profile mine(data)
# # Profile.print()
# ProfileView.view()
