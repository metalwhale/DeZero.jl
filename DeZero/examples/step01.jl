include("example.jl")
import DeZero: Variable

print(ndims(Variable([1 2 3; 4 5 6]).data))
