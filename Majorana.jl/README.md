# Majorana algebra implementation

Implemenation of Majorana algebra,
used to define spin operators (1/2 and 3/2)
in the context of PMFRG.

To prove (my) understanding,
this package implements the $S_i$ operators 
as described in papers and theses for spin 1/2 and 3/2,
and tests some known properties of said experssions
(see the `test()` function).

*This is not much more than a notebook*.

## Usage
### The bare minimum 

Activate the environment:
``` bash
julia --project=.
```
Optionally instantiate it, then:

```julia
using Majorana
test();
```

This will test the known equalities.
Have a look at the file `src/Majorana.jl` for more information.

### Hamiltonian

In `src/Hamiltonian.jl` a 2-site Hamiltonian for spin $3/2$ is written, 
using 10 different Majorana variables in the definition of the site.

The hamiltonian so constructed can be displayed in a latex form,
and rendered out in a browser using the Pluto notebook in `examples/notebook.jl`.
Coefficients are rendered to latex in a quite weird way, 
so the expressions are quite worse 
than the corresponding human-written ones,
but hopefully still useful.


## Lessons learned 
1. With this code I tested further 
   the opportunity of using Unicode to write code
   that looks like mathematical expressions,
   and it is, actually more limited than expected
   (e.g., there's no way to write something like $S_y$,
   since there's no $y$ subscript in Unicode).
   So, in order to make mathematical expression look nice,
   the only consisten approach seems to use Latexify.jl.

