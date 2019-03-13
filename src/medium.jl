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

# data = rand(Int8, 64*16);
# @btime chipsort_medium($data, Val(16), Val(8), Val(8));
# @btime sort($data);
# data = rand(Int8, 64*8);
# @btime chipsort_medium($data, Val(8), Val(8), Val(8));
# @btime sort($data);
# data = rand(Int8, 64*4);
# @btime chipsort_medium($data, Val(4), Val(8), Val(8));
# @btime sort($data);
# data = rand(Int8, 64*2);
# @btime chipsort_medium($data, Val(2), Val(8), Val(8));
# @btime sort($data);



function mine(reps)
    for _ in 1:reps
        data = rand(Int32, 128*64)
        chipsort_medium(data, Val(128), Val(8), Val(8))
    end
end

function base(reps)
    for _ in 1:reps
        data = rand(Int32, 128*64)
        sort(data)
    end
end

display(@benchmark base(10))
display(@benchmark mine(10))

# T=Float32
# C=128
# N=8
# L=8
# data = valloc(T, div(32, sizeof(T)), C*N*L)
# data .= rand(T, C*N*L)
# qq=chipsort_medium(data, Val(C), Val(N), Val(L))
# reshape(qq, 16,:)

using Profile
using ProfileView
Profile.clear()
@profile mine(1000)
#Profile.print()
ProfileView.view()


data = rand(Int32, 64*64)
@code_native chipsort_medium(data, Val(64), Val(8), Val(8))
