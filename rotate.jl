#=
14 February 2021
Lior Sinai


=#

using LinearAlgebra


function rotate2d(v::Matrix{T}, θ::Real) where T <: Real
    R= [
        cos(θ)  -sin(θ);
        sin(θ)  cos(θ)
    ]
    vr = R * v
   vr 
end

function rotate3d(v::AbstractMatrix{T}, R::Matrix{Float64}) where T <: Real  
    size(R) == (3,3) || throw(ArgumentError("size(R)=$(size(R)), must be a (3, 3) matrix"))
    det(R) ≈ 1.0 || throw(ArgumentError("det(R)=$(det(R)), must be 1.0"))
    R * v
end
