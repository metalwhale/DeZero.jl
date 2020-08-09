include("example.jl")
import DeZero: Variable, Square, Exp, backward

A = Square()
B = Exp()
C = Square()

x = Variable([0.5])
a = A(x)
b = B(a)
y = C(b)

y.grad = [1.0]
backward(y)
print(x.grad)