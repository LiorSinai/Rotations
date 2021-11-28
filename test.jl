#=
14 February 2021
Lior Sinai
=#

include("Rotations.jl")

using Test
using .Quaternions

println("Julia version: ", VERSION)
println("Running Quaternion tests ...")

@testset "constructor" begin

    q_real =  Quaternion(5.0)
    @test q_real.s == 5.0 && q_real.v1 == 0.0 && q_real.v2 == 0.0 && q_real.v3 == 0.0

    @test Quaternion{Float64}(5.0, 3, 2.0, 10) == Quaternion(5.0, 3.0, 2.0, 10.0) 

    q = Quaternion(5.0, 3.0, 2.0, 10.0) 


end

@testset "rotations" begin

    v = [1.0, 2.0, 3.0]
    vr = [0.30081737218229515, 1.3713874922529334, 3.4682568034512022]
    n = [0.4, 0.3, 1.0]
    V = [
        0.0 1.0 1.0;
        0.0 0.0 0.0;
        0.0 0.0 0.5
    ]

    q = quat_axis_angle(n, 1.0)
    q1 = q * Quaternion(v) * inv(q)
    vr1 = [q1.v1; q1.v2; q1.v3]
    vr2 = quat_to_matrix(q) * v
    @test vr1 ≈ vr
    @test vr2 ≈ vr
end

