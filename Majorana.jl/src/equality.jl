function Base.:(==)(s1::Sum, x::Number)
    if x == 0 && length(s1.terms) == 0 
        return true
    end
    length(s1.terms) == 1 && s1.terms[1].k ≈ x && length(s1.terms[1].ηs) == 0
end
function Base.:(==)(s1::Sum, s2::Sum)
    length(s1.terms) == length(s2.terms) &&
        all(isequal(ηsd1.k,  ηsd2.k) for (ηsd1, ηsd2) in zip(s1.terms, s1.terms))
end
Base.:(==)(s1::Sum{T}, ηs2::Product{S}) where {T,S} = s1 == Sum{T}([ηs2])
Base.:(==)(ηs2::Product, s1::Sum) = s1 == ηs2
