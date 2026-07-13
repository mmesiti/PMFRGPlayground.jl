import Majorana: Variable
import Symbolics: Num
import Latexify: latexify

ηxi = Variable(1,"\\eta^x_i")
ηyi = Variable(2,"\\eta^y_i")
ηzi = Variable(3,"\\eta^z_i")
θxi = Variable(4,"\\theta^x_i")
θzi = Variable(5,"\\theta^z_i")

# Using "Numeric Symbols" from Symbolics.jl
_3 = Num(3)
_2 = Num(2)

S₅i = (
    x = (im//_2) * (ηyi * ηzi - ηxi * (θzi - √_3 * θxi)),
    y = (im//_2) * (ηzi * ηxi - ηyi * (θzi + √_3 * θxi)),
    z = (im//_2) * (ηxi * ηyi + _2 * ηzi * θzi)
)

ηxj = Variable(1+5,"\\eta^x_j")
ηyj = Variable(2+5,"\\eta^y_j")
ηzj = Variable(3+5,"\\eta^z_j")
θxj = Variable(4+5,"\\theta^x_j")
θzj = Variable(5+5,"\\theta^z_j")

S₅j = (
    x = (im//_2) * (ηyj * ηzj - ηxj * (θzj - √_3 * θxj)),
    y = (im//_2) * (ηzj * ηxj - ηyj * (θzj + √_3 * θxj)),
    z = (im//_2) * (ηxj * ηyj + _2 * ηzj * θzj)
)


H = sum(S₅i[k]*S₅j[k] for k in 1:3)

function print_Hamiltonian_latex()
    println("latex representation of -4*H: ")
    println(latexify(-4*H))
end
