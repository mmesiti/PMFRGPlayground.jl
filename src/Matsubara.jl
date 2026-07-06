import Base
struct MatsubaraF
    w::Float64
end

# Basic information
Base.:(+)(w1::MatsubaraF, w2::MatsubaraF) = MatsubaraF(w1.w+w2.w)
Base.:(-)(w1::MatsubaraF, w2::MatsubaraF) = MatsubaraF(w1.w-w2.w)


matsubaras(N) = (MatsubaraF(i) for i in -N:N)

# TODO: think - we might need conversion functions
#       between matsubara frequencies and the corresponding
#       integer index in the data structure.
