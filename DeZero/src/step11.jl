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

function _function(f::Function, forward::Core.Function, inputs::Array{Variable})::Array{Variable}
    xs::Array{Array} = [x.data for x in inputs]
    ys::Tuple{Vararg{Array}} = forward(xs)
    outputs = [Variable(y) for y in ys]
    for output in outputs
        output.creator = f
    end
    f.inputs = inputs
    f.outputs = outputs
    return outputs
end

mutable struct Add <: Function
    inputs::Union{Array{Variable},Nothing}
    outputs::Union{Array{Variable},Nothing}
    Add() = new()
end
(f::Add)(inputs::Array{Variable})::Array{Variable} = _function(f, xs -> (xs[1] + xs[2],), inputs)
