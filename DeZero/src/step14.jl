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
        gys::Array{Array} = [output.grad for output in f.outputs]
        gxs::Union{Tuple{Vararg{Array}},Array} = backward(f, gys...)
        if !isa(gxs, Tuple)
            gxs = (gxs,)
        end
        for (x, gx) in zip(f.inputs, gxs)
            if isnothing(x.grad)
                x.grad = gx
            else
                x.grad += gx
            end
            if !isnothing(x.creator)
                push!(funcs, x.creator)
            end
        end
    end
end
function cleargrad(v::Variable)
    v.grad = nothing
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
backward(::Add, gy::Array)::Tuple{Array,Array} = gy, gy

mutable struct Square <: Function
    inputs::Union{Tuple{Vararg{Variable}},Nothing}
    outputs::Union{Array{Variable},Nothing}
    Square() = new()
end
(f::Square)(input::Variable)::Variable = _function(f, x -> x .^ 2, input)
square(x::Variable)::Variable = Square()(x)
backward(f::Square, gy::Array)::Array = 2 * f.inputs[1].data .* gy
