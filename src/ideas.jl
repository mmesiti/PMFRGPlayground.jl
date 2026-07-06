# Multi-Index
# From: https://arxiv.org/pdf/2307.10359, page 6, under Eq. 16
#
# x = (i, iω,μ)
#
# But we keep the site explicit, so
#
# x = (iω,f)
#
# Where:
# i : site index
# ω : matsubara frequency
# f : flavour

# (72) from S.R. notes 2026-06-39

flavours = 1:num_flavours

x = 1
y = 2
z = 3

# Possible different approaches:
# In every case, you need this DGamma(f1,f2,...,i,j,w1,w2...)
# 1. represent Gamma as an array of functions
# DGamma[]()
DGamma =  collect( (i,j, w1,w2,w3,w4) ->  let s = x1.ω + x2.ω,
                      t =  x1.ω + x3.ω,
                      u =  x1.ω + x4.ω

                      nothing # depends on f1,f2
                   end
                   for f1 in flavours,
                       f2 in flavours
                       )


# DGamma()()

#DGamma(i,j, f1, w1, f2, w2, f3, w3, f4, w4) = let s = x1.ω + x2.ω,

# convert from w1,w2,... to s, t, u is needed to find the derivatives
# to be fed to the ODE solver
DGamma(i,j, f1,,f2, f3, f4, s,t,u) = let w1 = (s+t+u)/2, w2 =...
    DGamma(i,j, f1, w1, f2, w2, f3, w3, f4, w4)
end

DGamma(f1,f2,...) = (i,j,...) -> ... # depends on f1,f2



    # Let's not use multiindices,
    # it makes things unnecessarily complicated
    # and the formalism maps quite trivially
    # to the non-multiindex code
    struct Mi
        f # flavour
        ω # Matsubara Frequency
    end

DGamma(i,j, x1::Mi,x2::Mi,x3::Mi,x4::Mi) = let s = x1.ω + x2.ω,
    t =  x1.ω + x3.ω,
    u =  x1.ω + x4.ω,

    1/β * sum( # ω
               (sum( # k
                     sum(
                         - Gamma(i,k,
                                 x1,
                                 x2,
                                 Mi(x1pf, ω) ,
                                 Mi(x4pf, - ω - s )) *
                                     Gamma(k,j,
                                           Mi(x2pf,-ω),
                                           Mi(x3pf, ω+s),
                                           x3,
                                           x4)*
                                               P(k,k,
                                                 x1pf,
                                                 x2pf,
                                                 x3pf,
                                                 x4pf,
                                                 - ω - s)
                         for x1pf in flavours,
                             x2pf in flavours,
                             x3pf in flavours,
                             x4pf in flavours
                             )
                     for k in sites)
                +
                    sum(
                        (Gamma(i,j,
                               x1,
                               Mi(x2pf,-ω),
                               x3,
                               Mi(x3pf,
                                  ω-t))*
                                      Gamma(i,j,
                                            x2,
                                            Mi(x1pf,ω),
                                            x4,
                                            Mi(x4pf,-ω+t))*
                                                P(i,j,
                                                  x1pf,
                                                  x2pf,
                                                  x3pf,
                                                  x4pf,
                                                  - ω + t)
                         + Gamma(i,j,
                                 x1,
                                 Mi(x3pf,ω-t),
                                 x3,
                                 Mi(x2pf,-ω))*
                                     Gamma(i,j,
                                           x2,
                                           Mi(x4pf, -ω+t),
                                           x4,
                                           Mi(x1pf, ω))*
                                               P(j,i,
                                                 x1pf,
                                                 x2pf,
                                                 x3pf,
                                                 x4pf,
                                                 - ω + t))
                        - (
                            ...
                                )





                        for x1pf in flavour_range,
                            x2pf in flavour_range,
                            x3pf in flavour_range,
                            x4pf in flavour_range

                            )



                ) for ω in ω_range )
end

#####3
