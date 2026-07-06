include("ExprManipulation.jl")
macro Σ(range,var,expr)
    newvar = gensym(var)
    expr = ExprManipulation.replace(expr,var,newvar)
    :(sum($(esc(expr)) for $(esc(newvar)) in $(esc(range)) ))
end
