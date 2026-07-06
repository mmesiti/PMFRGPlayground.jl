include("Flavour.jl")
include("Matsubara.jl")
include("sitesum.jl")

# "Sitepair" indices are in Sitesum, in "System/Geometry objects"
abstract type SitePair end
# "Site" indices are in PairTypes, in "System/Geometry objects"
abstract type Site end


#! format: off
P(f1::Flavour, f2::Flavour, f3::Flavour, f4::Flavour, # Flavours
  i::Site, j::Site, # Sites
  w::MatsubaraF, s::MatsubaraF, # Matsubaras
) = S(i, f1, f2, w) * G(j, f3, f4, w + s)
#! format: on

# TODO: take, e.g., from Yannik's PMFRG simplified code
G(i::Site, f1::Flavour, f2::Flavour, w::MatsubaraF) = nothing
S(i::Site, f1::Flavour, f2::Flavour, w::MatsubaraF) = nothing


#
#
# Note: all these types are used to reduce the possibility
#       of passing arguments in the wrong order.
# Notes about the equations in latex:
# 1. P's need to have two frequency args
# 2. instead of 1,2,3,4 in Γs we shoul use ω₁ ...
# 3. multiply RHS by δ(ω1+ω2, ω3+ω4)
# And publish this somewhere
# where it can be referenced.

#! format: off
"""
General form of the derivative of the 4-point vertex, $\Gamma$,
with respect to the flow parameter $\Lambda$.

This equation has been derived using these symmetries:
- Time-translation invariance
- Hermiticity
- Local Z(2) gauge symmetry

This equation has not used the following symmetries:
- any flavour symmetry
- time reversal
- any particular total spin

Additional symmetries used
(because of delegating site summation to SpinFRGLattices.jl):
- Spatial translation invariance up to the unit cell

In this form it is given in terms
of the 4 frequencies $\omega_1$, ..., $\omega_4$,
which are not linearly independent.

# Arguments
- `f1::Flavour`, `f2::Flavour`, `f3::Flavour`, `f4::Flavour`: flavours indices for the 4 legs
- `ij::SitePair`: the site pair, as defined in the SpinFRGLattices.jl package
- `w1::MatsubaraF`, `w2::MatsubaraF`, `w3::MatsubaraF`, `w4::MatsubaraF`: Matsubara frequencies for the 4 legs
   (not linearly independent)
- `T::Temperature`: The value of the temperature
- `geometry`: Geometry object containing all the information on the lattice geometry (see `struct Geometry` from SpinFRGLattices.jl)
- `Gamma`: A function representing the 4-point vertex, with the signature
   ```julia
   Gamma(f1::Flavour, f2::Flavour, f3::Flavour, f4::Flavour, # flavours
       ij::SitePair, # sitepair
       w1::MatsubaraF, w2::MatsubaraF, w3::MatsubaraF, w4::MatsubaraF, # matsubaras
   ```
- `P`: A function representing the product of the 2-point green function G and



# Additional notes
## Space translation symmetry
This is embodied by the fact that we are using a "geometry"
object coming from the
[SpinFRGLattices.jl package](https://github.com/NilsNiggemann/SpinFRGLattices.jl.git)

## Additional references
This represents
Eq (4) in Noah's "PMFRG at Full Anisotropy",
or Eq (72) in Siebe's PM-FRG for Heisenberg Spin 3/2.


"""
DGamma_(f1::Flavour, f2::Flavour, f3::Flavour, f4::Flavour, # flavours
    ij::SitePair, # sitepair
    w1::MatsubaraF, w2::MatsubaraF, w3::MatsubaraF, w4::MatsubaraF, # matsubaras
    T::Temperature,
    geometry, Gamma, P) =
    let s = w1 + w2, # PRB 103, 104431 Eq (22)
        t = w1 + w3,
        u = w1 + w4

        (; i, j) = geometry.PairTypes[ij]
        ss = geometry.siteSum[:,ij]

        T*sum( # for w in matsubaras
            sum( # for f1p,f2p,f3p,f4p
                (@sitesum ss ik kj xk - Gamma(f1, f2, f1p, f4p, # flavours
                                             ik, # sitepair
                                             w1, w2, w, -w-s, # matsubaras
                                             ) *
                                       Gamma(f2p, f3p, f3, f4, # flavours
                                             kj, # sitepair
                                             -w, w+s, w3, w4, # matsubaras
                                             ) *
                                       P(f1p, f2p, f3p, f4p, # flavours
                                         xk, xk, # sites
                                         -w, -s, # matsubara
                                         )
                 ) + (
                    Gamma(f1, f2p, f3, f3p, # flavours
                        ij, # sitepair
                        w1, -w, w3, w - t) # matsubaras
                    * Gamma(f2, f1p, f4, f4p, # flavours
                        ij, # sitepair
                        w2, w, w4, -w+t) # matsubaras
                    * P(f1p, f2p, f3p, f4p, # flavours
                        i, j,#sites
                        -w, +t) # matsubara
                    ####
                    + Gamma(f1, f3p, f3, f2p, # flavours
                        ij, # sitepair
                        w1, w-t, w3, -w) # matsubaras
                    * Gamma(f2, f4p, f4, f1p, # flavours
                        ij, # sitepair
                        w2, -w+t, w4, w) # matsubaras
                    * P(f1p, f2p, f3p, f4p, # flavours
                        j, i,#sites
                        -w, +t) # matsubara
                ) - (
                    Gamma(f1, f4p, f4, f1p, # flavours
                        ij, # sitepair
                        w1, -w-u, w4, w) # matsubaras
                    *Gamma(f2, f3p, f3, f2p,#flavours
                        ij, # sitepair
                        w2, w+u, w3, -w) # matsubaras
                    *P(f1p, f2p, f3p, f4p,# flavours
                        i, j, # sites
                        -w, -u) # matsubara
                    ####
                    + Gamma(f1, f1p, f4, f4p, # flavours
                        ij, # sitepair
                        w1, w, w4, -w-u) # matsubaras
                    * Gamma(f2, f2p, f3, f3p, # flavours
                        ij, # sitepair
                        w2, -w, 3, w+u) # matsubaras
                    * P(f1p, f2p, f3p, f4p, # flavours
                        j,i, # sites
                        -w, -u) # matsubaras
                    )
                 for f1p in flavours, f2p in flavours, f3p in flavours, f4p in flavours)
               for w in matsubaras)
    end # let s,t,u
#! format: on

DGamma_(f1::Flavour, f2::Flavour, f3::Flavour, f4::Flavour, # flavours
    ij::SitePair, # sitepair
    w1::MatsubaraF, w2::MatsubaraF, w3::MatsubaraF, w4::MatsubaraF, # matsubaras
    T::Temperature,
    geometry, Gamma) =
