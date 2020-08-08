include("example.jl")
import DeZero: Variable, Square

x = Variable([10])
f = Square()
y = f(x)
print(y)
