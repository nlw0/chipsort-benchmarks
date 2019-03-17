using SIMD

using Revise
using ChipSort

include("../../ChipSort.jl/test/testutils.jl")

T=Int8
V=8
J=8
K=4

aa = randa(T, V*J*K)

a1=copy(aa)
for k in 1:K
    sort_vecs!((@view aa[1+(k-1)*V*J:k*V*J]), Val(V), Val(J), Val(true))
end
a2=copy(aa)

aa.=a1
for k in 1:K
    sort_vecs!((@view aa[1+(k-1)*V*J:k*V*J]), Val(V), Val(J), Val(false))
end
a3=copy(aa)

transpose!(aa, Val(V), Val(K), Val(J))

display(reshape(aa, V,:))

using Plots
pyplot()

plot(a1, subplot=1, layout=4, m=:plus, l=2, label="rand")
plot!(a2, subplot=2, layout=4, m=:plus, l=2, label="8x8 sort&trans")
plot!(a3, subplot=3, layout=4, m=:plus, l=2, label="8x8 sort")
plot!(aa, subplot=4, layout=4, m=:plus, l=2, label="(8x8 sort)trans")
