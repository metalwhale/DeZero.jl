include("example.jl")
import DeZero: Variable, Square, Exp, numerical_diff

function f(x::Variable)::Variable
    A = Square()
    B = Exp()
    C = Square()
    return C(B(A(x)))
end

x = Variable([0.5])
dy = numerical_diff(f, x)
print(dy)
