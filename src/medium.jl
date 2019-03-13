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








# T=Float64
# C=128
# N=8
# L=8

# data = valloc(T, div(32, sizeof(T)), C*N*L)
# data .= rand(T, C*N*L)

# qq = chipsort_medium(data, Val(C), Val(N), Val(L))
# reshape(qq, 16,:)




using Profile
using ProfileView
Profile.clear()
@profile mine(1000)
# Profile.print()
ProfileView.view()


function base(reps)
    for _ in 1:reps
        data = rand(Int32, 128*64)
        sort(data)
    end
end

function mine(reps)
    for _ in 1:reps
        data = rand(Int32, 128*64)
        chipsort_medium(data, Val(128), Val(8), Val(8))
    end
end

display(@benchmark base(10))
display(@benchmark mine(10))


# data = rand(T, 64*64)
# @code_native
# chipsort_medium(data, Val(C), Val(N), Val(L)) == sort(data)


# println("First pass")
# aa = [x for _ in 1:C*L for x in sort(rand(T,N))]
# oo = zeros(T, C*L*N)

# C = C >> 1
# bitonic_merge_interleaved(
#     ntuple(c->pointer(oo, 1+(2*(c-1))*L*N), C),
#     ntuple(c->pointer(oo, 1+N+(2*(c-1))*L*N), C),
#     ntuple(c->pointer(aa, 1+(2*(c-1))*L*N), C),
#     ntuple(c->pointer(aa, 1+L*N+(2*(c-1))*L*N), C),
#     Val(N)
# )

# display(reshape(aa,N*L,:))
# display(reshape(oo,N*L*2,:))

# println("second pass")
# L = L << 1
# C = C >> 1
# aa = oo
# oo = zeros(T, 2*C*L*N)

# bitonic_merge_interleaved(
#     ntuple(c->pointer(oo, 1+(2*(c-1))*L*N), C),
#     ntuple(c->pointer(oo, 1+N+(2*(c-1))*L*N), C),
#     ntuple(c->pointer(aa, 1+(2*(c-1))*L*N), C),
#     ntuple(c->pointer(aa, 1+L*N+(2*(c-1))*L*N), C),
#     Val(N)
# )

# display(reshape(oo,N*L*2,:))

# bitonic_merge_interleaved(
#     ntuple(c->pointer(oo, 1+N+(2*(c-1))*L*N), C),
#     ntuple(c->pointer(oo, 1+2*N+(2*(c-1))*L*N), C),
#     ntuple(c->pointer(oo, 1+N+(2*(c-1))*L*N), C),
#     ntuple(c->
#            if aa[1+N+(2*(c-1))*L*N] < aa[1+N+L*N+(2*(c-1))*L*N]
#            pointer(aa, 1+N+(2*(c-1))*L*N)
#            else
#            pointer(aa, 1+N+L*N+(2*(c-1))*L*N)
#            end
#            , C),
#     Val(N)
# )


# display(reshape(oo,N*L*2,:))
