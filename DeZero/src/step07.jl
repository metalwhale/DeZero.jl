abstract type _Function end

mutable struct Variable
    data::Array
    grad::Array
    creator::_Function
    Variable(data) = new(data)
end
function backward(v::Variable)::Nothing
    if isdefined(v, :creator)
        f::_Function = v.creator
        x::Variable = f.input
        x.grad = backward(f, v.grad)
        backward(x)
    end
end

function _function(f::_Function, forward::Function, input::Variable)::Variable
    x = input.data
    y::Array = forward(x)
    output = Variable(y)
    output.creator = f
    f.input = input
    f.output = output
    return output
end

mutable struct Square <: _Function
    input::Variable
    output::Variable
    Square() = new()
end
(s::Square)(input::Variable)::Variable = _function(s, x -> x .^ 2, input)
backward(s::Square, gy::Array) = 2 * s.input.data .* gy

mutable struct Exp <: _Function
    input::Variable
    output::Variable
    Exp() = new()
end
(s::Exp)(input::Variable)::Variable = _function(s, x -> exp.(x), input)
backward(e::Exp, gy::Array) = exp.(e.input.data) .* gy
