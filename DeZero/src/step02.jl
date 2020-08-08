function _function(forward::Function, input::Variable)::Variable
    x = input.data
    y = forward(x)::Array
    output = Variable(y)
    return output
end

struct Square end
(::Square)(input::Variable)::Variable = _function(x -> x .^ 2, input)
