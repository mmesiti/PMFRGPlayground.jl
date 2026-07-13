
Base.isless(ηs1::Product, ηs2::Product) = ηs1.ηs < ηs2.ηs
###############
# Unary Minus #
###############
Base.:-(η::Variable{T}) where {T} = Product{T}([η], -1)
Base.:-(ηs::Product{T}) where {T} = Product{T}(ηs.ηs, -ηs.k)
Base.:-(s::Sum{T}) where {T} = Sum{T}([-ηs for ηs in s.terms])


####################
# Binary functions #
####################
# We need in principle methods for all combinations of types:
# - Numbers
# - Variables
# - Product
# - Sum
# Not all possible methods implemented,
# only a superset of the ones needed to make tests work


############
# Addition #
############
Base.:+(η1::Variable{T}, η2::Variable{T}) where {T} =
    Product{T}([η1], 1) + Product{T}([η2], 1)
Base.:+(ηs1::Product{T}, η2::Variable{T}) where {T} = ηs1 + Product{T}([η2], 1)
Base.:+(η1::Variable{T} , ηs2::Product{T}) where {T} = ηs2 + η1
Base.:+(ηs1::Product{T}, ηs2::Product{T}) where {T} = Sum{T}([ηs1]) + ηs2
Base.:+(ηs1::Product, s2::Sum) = s2 + ηs1
function Base.:+(s1::Sum{T}, ηs2::Product{T}) where {T}

    new_terms = Vector{Product{T}}()
    found_match = false
    for ηs1 in s1.terms
        if ηs1.ηs == ηs2.ηs && !found_match
            found_match = true
            new_coefficient = ηs1.k + ηs2.k
            if ! isequal(new_coefficient, 0)
                push!(new_terms, Product{T}(ηs1.ηs, new_coefficient))
            end
        else
            push!(new_terms, ηs1)
        end
    end
    if !found_match
        push!(new_terms, ηs2)
    end

    Sum{T}(new_terms)
end
function Base.:+(s1::Sum{T}, s2::Sum{T}) where {T}
    res = Sum{T}(s1.terms)
    for ηs in s2.terms
        res += ηs
    end
    return res
end

###############
# Subtraction #
###############
Base.:-(η1::Variable{T}, η2::Variable{T}) where {T} =
    Product{T}([η1], 1) - Product{T}([η2], 1)
Base.:-(η1::Variable{T}, ηs2::Product{T}) where {T} = η1 + (-1 * ηs2)
Base.:-(ηs1::Product{T}, η2::Variable{T}) where {T} = ηs1 + Product{T}([η2], -1)
Base.:-(ηs1::Product{T}, ηs2::Product{T}) where {T} = Sum{T}([ηs1]) - ηs2
Base.:-(ηs1::Product, s2::Sum) = ηs1 + (-s2)
Base.:-(s1::Sum, ηs2::Product) = (s1 + (-ηs2))
Base.:-(s1::Sum, s2::Sum) = s1 + (-s2)


################## 
# Multiplication # 
################## 

Base.:*(x::Number, η::Variable{T}) where {T} = Product{T}([η], x)
Base.:*(η::Variable, x::Number) = x * η

function Base.:*(ηs::Product{T}, η::Variable{T}) where {T}
    if length(ηs.ηs) == 0 # product is scalar
        Product{T}([η], ηs.k)
    elseif length(ηs.ηs) == 1 # product is variable
        (ηs.ηs[1] * η) * ηs.k
    elseif ηs.ηs[end] < η
        Product{T}(vcat(ηs.ηs, [η]), ηs.k)
    elseif ηs.ηs[end] == η
        Product{T}(ηs.ηs[1:end-1], ηs.k * η²)
    else # ηs.ηs[end] > η
        last_η = ηs.ηs[end]
        # Recursion !
        (Product{T}(ηs.ηs[1:end-1], -ηs.k) * η) * last_η
    end
end

Base.:*(ηs::Product{T}, x::Number) where {T} = Product{T}(ηs.ηs, ηs.k * x)
Base.:*(x::Number, ηs::Product) = ηs * x

function Base.:*(ηs1::Product{T}, ηs2::Product{T}) where {T}

    if length(ηs1.ηs) == 0
        Product{T}(ηs2.ηs, ηs1.k * ηs2.k)
    elseif length(ηs2.ηs) == 0
        Product{T}(ηs1.ηs, ηs1.k * ηs2.k)
    else
        res = Product{T}(ηs1.ηs, ηs1.k)
        for η in ηs2.ηs
            res *= η
        end
        res *= ηs2.k
        return res
    end
end

function Base.:*(η1::Variable{T}, η2::Variable{T}) where {T}
    if η1.i < η2.i
        Product{T}([η1, η2], 1)
    elseif η2.i < η1.i
        Product{T}([η2, η1], -1)
    else
        Product{T}([], η²)
    end
end

# *
function Base.:*(s1::Sum{T}, s2::Sum{T}) where {T}
    res = Sum{T}(Vector{Product{T}}())
    for ηs1 in s1.terms, ηs2 in s2.terms
        res += (ηs1 * ηs2)
    end

    return res
end
function Base.:*(s1::Sum{T}, ηs2::Product{T}) where {T}
    res = Sum{T}(Vector{Product{T}}())
    for ηs1 in s1.terms
        res += ηs1 * ηs2
    end
    return res
end
function Base.:*(ηs1::Product{T}, s2::Sum{T}) where {T}
    res = Sum{T}(Vector{Product{T}}())
    for ηs2 in s2.terms
        res += ηs1 * ηs2
    end
    return res
end

Base.:*(s1::Sum{T}, x::Number) where {T} = Sum{T}([ηs * x for ηs in s1.terms])
Base.:*(x::Number, s1::Sum) = s1 * x
Base.:*(s1::Sum{T}, η::Variable{T}) where {T} = s1 * (1 * η)
Base.:*(η::Variable{T}, s1::Sum{T}) where {T} = (1 * η) * s1
