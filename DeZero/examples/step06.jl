include("example.jl")
import DeZero: Variable, Square, Exp

A = Square()
B = Exp()
C = Square()

x = Variable([0.5])
a = A(x)
b = B(a)
y = C(b)

y.grad = [1.0]
b.grad = C.backward(y.grad)
a.grad = B.backward(b.grad)
x.grad = A.backward(a.grad)
print(x.grad)
