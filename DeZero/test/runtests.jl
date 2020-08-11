using Test
using DeZero

function numerical_diff(f::Union{Function,Core.Function}, x::Variable, eps::Float64=1e-4)::Array
    x0 = Variable(x.data .- eps)
    x1 = Variable(x.data .+ eps)
    y0::Variable = f(x0)
    y1::Variable = f(x1)
    return (y1.data - y0.data) / (2 * eps)
end

@testset "SquareTest" begin
    @testset "test_forward" begin
        x = Variable([2.0])
        y = square(x)
        expected = [4.0]
        @test y.data == expected
    end

    @testset "test_backward" begin
        x = Variable([3.0])
        y = square(x)
        backward(y)
        expected = [6.0]
        @test x.grad == expected
    end
end

@testset "SquareTest" begin
    @testset "test_gradient_check" begin
        x = Variable(rand(1))
        y = square(x)
        backward(y)
        num_grad = numerical_diff(square, x)
        @test x.grad ≈ num_grad
    end
end
