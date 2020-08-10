include("example.jl")
import DeZero: Variable, square, exp, backward

x = Variable([0.5])
y = square(exp(square(x)))
backward(y)
print(x.grad)
