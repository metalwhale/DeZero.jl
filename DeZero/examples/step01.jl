import Pkg
Pkg.activate(joinpath(@__DIR__, ".."));
Pkg.instantiate()

using Revise
import DeZero: Variable

function test()
    print(ndims(Variable([1 2 3; 4 5 6]).data))
end
