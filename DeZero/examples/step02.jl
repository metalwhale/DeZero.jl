include("example.jl")
import DeZero: Variable, Square

function test()
    x = Variable([1 2 3; 4 5 6])
    f = Square()
    y = f(x)
    print(y)
end
