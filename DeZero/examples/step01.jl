include("example.jl")
import DeZero: Variable

function test()
    print(ndims(Variable([1 2 3; 4 5 6]).data))
end
