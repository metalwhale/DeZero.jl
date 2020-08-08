function numerical_diff(f::Union{_Function,Function}, x::Variable, eps::Float64=1e-4)
    x0 = Variable(x.data .- eps)
    x1 = Variable(x.data .+ eps)
    y0::Variable = f(x0)
    y1::Variable = f(x1)
    return (y1.data - y0.data) / (2 * eps)
end
