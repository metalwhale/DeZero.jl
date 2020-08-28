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

function _function(
    f::Function, forward::Core.Function, inputs::Variable...
)::Union{Array{Variable},Variable}
    xs::Array{Array} = [x.data for x in inputs]
    ys::Union{Tuple{Vararg{Array}},Array} = forward(xs...)
    if !isa(ys, Tuple)
        ys = (ys,)
    end
    outputs = [Variable(y) for y in ys]
    for output in outputs
        output.creator = f
    end
    f.inputs = inputs
    f.outputs = outputs
    return length(outputs) > 1 ? outputs : outputs[1]
end

mutable struct Add <: Function
    inputs::Union{Tuple{Vararg{Variable}},Nothing}
    outputs::Union{Array{Variable},Nothing}
    Add() = new()
end
(f::Add)(inputs::Variable...)::Variable = _function(f, (x0, x1) -> x0 + x1, inputs...)
add(x0::Variable, x1::Variable)::Variable = Add()(x0, x1)
