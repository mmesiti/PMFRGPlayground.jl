### A Pluto.jl notebook ###
# v1.0.1

using Markdown
using InteractiveUtils

# ╔═╡ 651a5811-6bd0-457a-a59e-c3eecaf99a77
using Pkg

# ╔═╡ 50453dfa-c85a-4220-a06e-bb33a6d7012f
Pkg.activate(".")

# ╔═╡ bd809ca4-d862-4d2d-bb10-74941615286d
using Latexify

# ╔═╡ d78b29b9-6958-4ff3-9c44-b697025f9b96
include("../src/Hamiltonian.jl")

# ╔═╡ 7d683233-9e2b-459b-859e-8462f8641b61
H

# ╔═╡ f2e16635-7e32-4b13-b1cc-6267e452b821
latexify(H)

# ╔═╡ 8fab47c2-328d-42c5-93e1-d7b09e6c419e
println(latexify(H))

# ╔═╡ f25f2330-44ca-4cfa-a493-49bb83c901f0


# ╔═╡ Cell order:
# ╠═651a5811-6bd0-457a-a59e-c3eecaf99a77
# ╠═50453dfa-c85a-4220-a06e-bb33a6d7012f
# ╠═d78b29b9-6958-4ff3-9c44-b697025f9b96
# ╠═7d683233-9e2b-459b-859e-8462f8641b61
# ╠═bd809ca4-d862-4d2d-bb10-74941615286d
# ╠═f2e16635-7e32-4b13-b1cc-6267e452b821
# ╠═8fab47c2-328d-42c5-93e1-d7b09e6c419e
# ╠═f25f2330-44ca-4cfa-a493-49bb83c901f0
