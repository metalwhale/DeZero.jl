mutable struct Variable
    data::Array
    grad::Array
    Variable(data) = new(data)
end

abstract type _Function end
function (f::_Function)(input::Variable)::Variable
    x = input.data
    y::Array = f.forward(x)
    output = Variable(y)
    f.input = input
    return output
end

mutable struct Square <: _Function
    input::Variable
    forward::Function
    backward::Function
    function Square()
        s = new()
        s.forward = x -> x .^ 2
        s.backward = gy -> 2 * s.input.data .* gy
        return s
    end
end

mutable struct Exp <: _Function
    input::Variable
    forward::Function
    backward::Function
    function Exp()
        e = new()
        e.forward = x -> exp.(x)
        e.backward = gy -> exp.(e.input.data) .* gy
        return e
    end
end
