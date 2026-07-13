module Majorana
using Test
using LaTeXStrings
using Symbolics


const η² = 1 / 2


################################
struct Variable{T<:Integer}
    i::T
    repr::LaTeXString
end

Variable(i) = Variable(i,L"")
Variable(i,s::String) = Variable(i,LaTeXString("\$$s\$"))

Base.isless(η1::Variable, η2::Variable) = η1.i < η2.i


################################
"Ordered product of variables with a coefficient"
struct Product{T<:Integer}
    # Sorted array
    ηs::Vector{Variable{T}}
    k::Number

    Product{T}(_ηs, _k) where {T} = begin
        if isequal(_k,0)
            # a 0-coefficient product is 0
            new{T}([], 0)
        else
            new{T}(sort(_ηs), _k)
        end
    end
end
"Scalar case"
Product(x) = Product(Vector{Variable{Int64}}(), x)

################################
"A sum of products of variables, each with a coefficient."
struct Sum{T<:Integer}
    terms::Vector{Product{T}}
    Sum{T}(_terms::Vector{Product{T}}) where {T} = new{T}(
        sort(collect(t for t in _terms
                         if ! isequal(t.k,0))))
end

include("arithmetic_operations.jl")
include("latexify_extension.jl")

J⁺(S) = S.x + 1 * im * S.y
J⁻(S) = S.x - 1 * im * S.y
J²(S) = sum(S[i]*S[i] for i in 1:3)

η₁ = Variable(1)
η₂ = Variable(2)
η₃ = Variable(3)

S₃ = (x = -im * η₂ * η₃,
      y = -im * η₃ * η₁,
      z = -im * η₁ * η₂,
      )

J₃⁺, J₃⁻ = J⁺(S₃), J⁻(S₃)
J₃² = J²(S₃)

η₄ = Variable(4)
η₅ = Variable(5)

_3 = Num(3) # From Symbolics
S₅ = (
    x = im * (η₃ * (√_3 * η₅ - η₂) + η₄ * η₁),
    y = im * (η₁ * η₃ - η₄ * (√_3 * η₅ + η₂)),
    z = im * (2 * η₁ * η₂ + η₃ * η₄),
)

J₅⁺, J₅⁻ = J⁺(S₅), J⁻(S₅)
J₅² = J²(S₅)

include("show.jl")
include("equality.jl")

commutator(a, b) = a * b - b * a

function test()
    @testset verbose = true begin
        @testset verbose = true for (d,S, J²_exp) in [(3,S₃, 3 / 4), (5,S₅, 15 / 4)]
            @testset verbose=true "S $d commutation relations" begin
                @testset verbose = true  for (a, b, c) in [(1, 2, 3), (2, 3, 1), (3, 1, 2)]
                    @test commutator(S[a], S[b]) == im * S[c]
                    @test commutator(S[b], S[a]) == -im * S[c]
                end
            end

            @testset "[S³, J±]" begin
                Jd⁺ = J⁺(S)
                Jd⁻ = J⁻(S)

                @test commutator(S.z, Jd⁺) == Jd⁺
                @test commutator(S.z, Jd⁻) == -Jd⁻
            end
            @testset "J²" begin
                Jd² = J²(S)
                @test Jd².terms[1].k == J²_exp
                @test commutator(Jd²,S.x) == 0
                @test commutator(Jd²,S.y) == 0
                @test commutator(Jd²,S.z) == 0
            end
        end
    end
end

export η1, η2, η3, η4, η5
export commutator, test

end # module Majorana
