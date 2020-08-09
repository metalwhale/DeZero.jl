mutable struct Variable
    data::Array
    grad::Array
    Variable(data) = new(data)
end

abstract type _Function end
function _function(f::_Function, forward::Function, input::Variable)::Variable
    x = input.data
    y::Array = forward(x)
    output = Variable(y)
    f.input = input
    return output
end

mutable struct Square <: _Function
    input::Variable
    Square() = new()
end
(s::Square)(input::Variable)::Variable = _function(s, x -> x .^ 2, input)
backward(s::Square, gy::Array) = 2 * s.input.data .* gy

mutable struct Exp <: _Function
    input::Variable
    Exp() = new()
end
(s::Exp)(input::Variable)::Variable = _function(s, x -> exp.(x), input)
backward(e::Exp, gy::Array) = exp.(e.input.data) .* gy
