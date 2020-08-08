function _function(forward::Function, input::Variable)::Variable
    x = input.data
    y::Array = forward(x)
    output = Variable(y)
    return output
end

abstract type _Function end
struct Square <: _Function end
(::Square)(input::Variable)::Variable = _function(x -> x .^ 2, input)
