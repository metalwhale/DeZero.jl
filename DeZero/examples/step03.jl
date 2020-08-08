include("example.jl")
import DeZero: Variable, Square, Exp

function test()
    A = Square()
    B = Exp()
    C = Square()
    x = Variable([0.5])
    a = A(x)
    b = B(a)
    y = C(b)
    print(y)
end