struct Flavour
    f::Int64
end

flavours(nflavours) = (Flavour(i) for i in 1:nflavours)
