using Latexify
using LaTeXStrings

function strip_dollars(s::LaTeXString)
    if s[1] == s[end] == '$'
        LaTeXString(s[2:end-1])
    else
        s
    end

end


function majorana_latexify(x::Majorana.Variable)
	return x.repr;
end

function majorana_latexify(p::Majorana.Product)

    pref_num,reality = if isreal(p.k)
        (real(p.k),true)
    elseif isreal(-p.k*im)
        (-p.k*im, false)
    else (p.k,true) end
    aaa= (isequal(sign(pref_num), -1))
    pref_num_abs = ifelse(aaa, -pref_num, pref_num)

    prefactor = if !isequal(p.k, 1) "$(strip_dollars(latexify(pref_num_abs))) " else "+" end
    prefactor *= if (! reality) "I" else "" end

    prefactor = replace(prefactor,
                        "\\begin{equation}\n" => "",
                        "\n\\end{equation}\n" => "",
                        )


    res =  prefactor * join("$(strip_dollars(majorana_latexify(x))) " for x in p.ηs);
    return LaTeXString("\$"*strip(res)*"\$");
end

function majorana_latexify(s::Majorana.Sum)

    # TODO: fix this
    signs = (sign(p.k) for p in s.terms)
    joins = [ if (typeof(s) <: Real) && (s > 0 ) "+" else "" end for s in signs]
    parts = ["$(strip_dollars(majorana_latexify(p)))" for p in s.terms]
    res = parts[1]
    for (j,p) in zip(joins,parts[2:end])
        res *= " \\\\\n"
        res *= j
        res *= p
    end

    return LaTeXString("\\begin{equation}\n\\begin{aligned}\n"
                       *strip(res)
                       *"\n\\end{aligned}\n\\end{equation}");

end



@latexrecipe function ml(x::Majorana.Variable)
    return majorana_latexify(x);
end

@latexrecipe function ml(p::Majorana.Product)
    return majorana_latexify(p);
end

@latexrecipe function ml(s::Majorana.Sum)
    return majorana_latexify(s);
end
