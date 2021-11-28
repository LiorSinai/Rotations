#=
6 November 2021
Lior Sinai
=#

include("Rotations.jl")
using .Rotations
using Random


println("Julia version: ", VERSION)
println("Running benchmarks ...\n")

# -------------------- setup -------------------- #

rng = MersenneTwister(2718)
normals = Vector[]
vectors = Vector[]
angles  = Float64[]
trials = 1_000_000
for i in 1:trials
    push!(normals, rand(rng, 3))
    push!(vectors, rand(rng, 3))
    θ =  rand(rng) * (4π) - 2π  # values between -2π and 2π
    push!(angles, θ)
end

results = Dict{String, Vector{Vector}}()
results["rodrigues"] = Vector[]
results["rodrigues vec"] = Vector[]
results["quaternion"] = Vector[]
results["pauli"] = Vector[]

# -------------------- compile -------------------- #
rotate_quat(vectors[1], normals[1], angles[1])
rotate_rodrigues(vectors[1], normals[1], angles[1])
rotate_rodrigues_vec(vectors[1], normals[1], angles[1])
rotate_pauli(vectors[1], normals[1], angles[1])

# -------------------- trials -------------------- #
println("quaternion")
@time for i in 1:trials
    vr = rotate_quat(vectors[i], normals[i], angles[i])
    push!(results["quaternion"], vr)
end
println("rodrigues vec")
@time for i in 1:trials
    vr = rotate_rodrigues_vec(vectors[i], normals[i], angles[i])
    push!(results["rodrigues vec"], vr)
end
println("rodrigues")
@time for i in 1:trials
    vr = rotate_rodrigues(vectors[i], normals[i], angles[i])
    push!(results["rodrigues"], vr)
end
println("pauli")
@time for i in 1:trials
    vr = rotate_pauli(vectors[i], normals[i], angles[i])
    push!(results["pauli"], vr)
end
println("")

# -------------------- divergence -------------------- #
println("divergence - baseline: quaternion")
for name in ["rodrigues vec", "rodrigues", "pauli"]
    delta = results["quaternion"] - results[name]
    divergence = 0.0
    for v in delta
        divergence += sqrt(sum(v.^2))
    end
    println(name)
    println("total:   ", divergence)
    println("average: ", divergence/length(delta))
end
