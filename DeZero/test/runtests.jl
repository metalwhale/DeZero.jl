using Test
using DeZero

function numerical_diff(f::Union{Function,Core.Function}, x::Variable, eps::Float64=1e-4)::Array
    x0 = Variable(x.data .- eps)
    x1 = Variable(x.data .+ eps)
    y0::Variable = f(x0)
    y1::Variable = f(x1)
    return (y1.data - y0.data) / (2 * eps)
end

x = Variable([3.0])
y = add(x, x)
backward(y)
println(x.grad)

cleargrad(x)
y = add(add(x, x), x)
backward(y)
println(x.grad)
