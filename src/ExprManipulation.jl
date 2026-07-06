module ExprManipulation
"""
Replaces a symbol in an expression
with a new symbol
wherever it occurs.

# Arguments
- `ex::Expr`: the expression to process
- `to_replace::Symbol`: the symbol to replace in `ex`
- `new::Symbol`: the symbol which needs to be put in place of `to_replace` in `ex`

# Examples
```jldoctest
julia> replace(:(f(a,b,c) + g(a+1,b)), :a, :e)
:(f(e,b,c) + g(e+1,b))
```
"""
function replace(ex::Expr,to_replace::Symbol,new::Symbol)
    Expr(ex.head, [ replace(arg,to_replace,new) for arg in ex.args]...)
end

macro replace(ex)
    esc(replace(ex))
end

#

function replace(ex::Expr)
    template = find_template(ex)
    replace_dicts(template,ex)
end

##

function find_template(expr)
	if ! has_symbol_dict(expr) expr else first(map(find_template,expr.args[2:end])) end
end

replace_dicts(template::Expr,e) = e
function replace_dicts(template::Expr,e::Expr)
	Expr(e.head, [ if is_symbol_dict(se)
                      replace(template,eval(se))
                   else replace_dicts(template,se)
                   end for se in e.args ]...)
end

###

has_symbol_dict(ex) = false

function has_symbol_dict(ex::Expr)
	is_symbol_dict(ex) ||
	    any(map(has_symbol_dict,ex.args))
end

function is_symbol_dict(ex)
    try
        if typeof(eval(ex)) == Dict{Symbol,Symbol}
            true
        else
            false
        end
    catch
        false
    end
end

function replace(ex::Expr,replacements::Dict{Symbol,Symbol})
    Expr(ex.head, [ replace(a,replacements) for a in ex.args]...)
end

replace(s0::Symbol,replacements::Dict{Symbol,Symbol}) = get(replacements,s0,s0)
replace(ex,::Dict{Symbol,Symbol}) = ex

####

replace(ex,::Symbol,new::Symbol) = ex
replace(s0::Symbol,to_replace::Symbol,new::Symbol) = (s0 == to_replace) ? new  : s0


end
