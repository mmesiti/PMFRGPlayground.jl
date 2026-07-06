include("Flavour.jl")
include("Matsubara.jl")
include("sitesum.jl")

# "Sitepair" indices are in Sitesum, in "System/Geometry objects"
abstract type SitePair end
# "Site" indices are in PairTypes, in "System/Geometry objects"
abstract type Site end


P(f1::Flavour,f2::Flavour,f3::Flavour,f4::Flavour, # Flavours
  i::Site,j::Site, # Sites
  w::MatsubaraF,s::MatsubaraF # Matsubaras
  ) =
    S(i,f1,f2, w) * G(j,f3,f4,w + s)
end

S(i::Site,f1::Flavour,f2::Flavour, w::MatsubaraF) = nothing # TODO: take, e.g., from Yannik's PMFRG simplified code
G(i::Site,f1::Flavour,f2::Flavour, w::MatsubaraF) = nothing # TODO: take, e.g., from Yannik's PMFRG simplified code


# Eq (4) in Noah's "PMFRG at Full Anisotropy",
# or Eq (72) in Siebe's PM-FRG for Heisenberg Spin 3/2
# Note: all these types are used to reduce the possibility
#       of passing arguments in the wrong order.
# Notes about the equations in latex:
# 1. P's need to have two frequency args
# 2. instead of 1,2,3,4 in Γs we shoul use ω₁ ...
# 3. multiply RHS by δ(ω1+ω2, ω3+ω4)
# And publish this somewhere
# where it can be referenced.

DGamma_(f1::Flavour, f2::Flavour, f3::Flavour, f4::Flavour, # flavours
        ij::SitePair, # sitepair
        w1::MatsubaraF, w2::MatsubaraF, w3::MatsubaraF, w4::MatsubaraF, # matsubaras
        T::Temperature,
        geometry,
        ) = let s = w1 + w2, # PRB 103, 104431 Eq (22)
            t = w1 + w3,
            u = w1 + w4,
            ji = geometry.invpairs[ij]
            (;i,j) = geometry.PairTypes[ij]

            T*sum( # for w in matsubaras
                   sum( # for f1p,f2p,f3p,f4p
                        (@sitesum geometry.siteSum ik kj k
                         - Gamma(f1,f2,f1p,f4p, # flavours
                                 ik, # sitepair
                                 w1,w2,w,-w-s # matsubaras
                                 )* Gamma(f2p,f3p,f3,f4, # flavours
                                          kj, # sitepair
                                          -w,w+s,w3,w4 # matsubaras
                                          )* P(f1p,f2p,f3p,f4p, # flavours
                                               k,k, # sites
                                               -w,-s # matsubara
                                               ))
                        + (
                            Gamma(f1,f2p,f3,f3p, # flavours
                                  ij, # sitepair
                                  w1,-w,w3,w-t # matsubaras
                                  )* Gamma(f2,f1p,f4,f4p, # flavours
                                           ij, # sitepair
                                           w2,w,w4,-w+t # matsubaras
                                           )*P(f1p,f2p,f3p,f4p, # flavours
                                               i,j,#sites
                                               -w,+t # matsubara
                                               ) +
                            Gamma(f1,f3p,f3,f2p, # flavours
                                  ij, # sitepair
                                  w1,w-t,w3,-w # matsubaras
                                  )* Gamma(f2,f4p,f4,f1p, # flavours
                                           ij, # sitepair
                                           w2,-w+t,w4,w # matsubaras
                                           )*P(f1p,f2p,f3p,f4p, # flavours
                                               j,i,#sites
                                               -w,+t # matsubara
                                               ))
                        - ( Gamma(f1,f4p,f4,f1p, # flavours
                                  ij, # sitepair
                                  w1,-w-u,w4,w # matsubaras
                                  )*Gamma(f2,f3p,f3,f2p,#flavours
                                          ij, # sitepair
                                          w2,w+u,w3,-w # matsubaras
                                          )*P(f1p,f2p,f3p,f4p,# flavours
                                              i,j, # sites
                                              -w,-u # matsubara
                                              )+
                          Gamma(f1,f1p,f4,f4p, # flavours
                                ij, # sitepair
                                w1,w,w4,-w-u
                                )*Gamma(f2,f2p,f3,f3p,
                                        ij,
                                        w2,-w,3,w+u
                                        )*P(f1p,f2p,f3p,f4p, # flavours
                                            j,i, # sites
                                            -w,-u # matsubaras
                                            ))

                        for f1p in flavours,
                            f2p in flavours,
                            f3p in flavours,
                            f4p in flavours)
                   for w in matsubaras)
        end # let s,t,u

