include("kronecker-delta.jl")

module Propagators

# (15)
G₀⁻¹(μ₁,ω₁,μ₂,ω₂,A,β) = ( im*ω₁*δ₃ - im*A)[μ₁,μ₂] * β * δ(ω₁,-ω₂)

# (21)
G₀(Λ ,μ₁,ω₁,μ₂,ω₂,A,β) =  Θ(Λ) G₀(μ₁,ω₁,μ₂,ω₂,A,β)


end
