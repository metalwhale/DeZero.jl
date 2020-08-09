abstract type _Function end

mutable struct Variable
    data::Array
    grad::Union{Array,Nothing}
    creator::Union{_Function,Nothing}
    Variable(data) = new(data, nothing, nothing)
end
function backward(v::Variable)::Nothing
    funcs::Array{_Function} = [v.creator]
    while !isempty(funcs)
        f::_Function = pop!(funcs) # No need to check for nothingness at the first time
        x::Variable, y::Variable = f.input, f.output
        x.grad = backward(f, y.grad)
        if !isnothing(x.creator)
            push!(funcs, x.creator)
        end
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
    input::Union{Variable,Nothing}
    output::Union{Variable,Nothing}
    Square() = new()
end
(s::Square)(input::Variable)::Variable = _function(s, x -> x .^ 2, input)
backward(s::Square, gy::Array)::Array = 2 * s.input.data .* gy

mutable struct Exp <: _Function
    input::Union{Variable,Nothing}
    output::Union{Variable,Nothing}
    Exp() = new()
end
(s::Exp)(input::Variable)::Variable = _function(s, x -> exp.(x), input)
backward(e::Exp, gy::Array)::Array = exp.(e.input.data) .* gy
