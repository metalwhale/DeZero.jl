import Base.exp

abstract type Function end

mutable struct Variable
    data::Array
    grad::Union{Array,Nothing}
    creator::Union{Function,Nothing}
    Variable(data) = new(data, nothing, nothing)
end
function backward(v::Variable)::Nothing
    if isnothing(v.grad)
        v.grad = ones(size(v.data))
    end
    funcs::Array{Function} = [v.creator]
    while !isempty(funcs)
        f::Function = pop!(funcs) # No need to check for nothingness at the first time
        x::Variable, y::Variable = f.input, f.output
        x.grad = backward(f, y.grad)
        if !isnothing(x.creator)
            push!(funcs, x.creator)
        end
    end
end

function _function(f::Function, forward::Core.Function, input::Variable)::Variable
    x = input.data
    y::Array = forward(x)
    output = Variable(y)
    output.creator = f
    f.input = input
    f.output = output
    return output
end

mutable struct Square <: Function
    input::Union{Variable,Nothing}
    output::Union{Variable,Nothing}
    Square() = new()
end
(s::Square)(input::Variable)::Variable = _function(s, x -> x .^ 2, input)
backward(s::Square, gy::Array)::Array = 2 * s.input.data .* gy
square(x::Variable)::Variable = Square()(x)

mutable struct Exp <: Function
    input::Union{Variable,Nothing}
    output::Union{Variable,Nothing}
    Exp() = new()
end
(s::Exp)(input::Variable)::Variable = _function(s, x -> exp.(x), input)
backward(e::Exp, gy::Array)::Array = exp.(e.input.data) .* gy
exp(x::Variable)::Variable = Exp()(x)
