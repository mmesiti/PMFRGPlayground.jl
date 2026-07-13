
Base.show(io::IO, η::Variable) = if η.repr == "" print(io, "η$(η.i)") else print(io,η.repr) end
function Base.show(io::IO, s::Sum)
    print(io, "[" * join(["$(t)" for t in s.terms], " +") * "]")
end

function Base.show(io::IO, ηs::Product)
    k = ηs.k
    prefix = if isequal(real(k),0)
        let q =real(-k*im)
            "$q I"
        end
        elseif isequal(imag(k),0)
        let q =real(k)
            "$q"
        end
        end
    bits = [prefix]
    for η in ηs.ηs
        push!(bits, "$η")
    end
    print(io, "(" * join(bits, " ") * ")")
end
