using LinearAlgebra

function rotate_rodrigues(v::AbstractArray, n::AbstractVector, θ::AbstractFloat)
    if length(n) != 3
        error("normal axis must be a 3-vector")
    end
    n_norm = sqrt(sum(n.^2))
    n_unit = n / n_norm
    K = [
        +0.0       -n_unit[3]  n_unit[2];
        +n_unit[3]  0.0       -n_unit[1];
        -n_unit[2]  n_unit[1]  0.0
    ]
    I3 = [
        1.0 0.0 0.0;
        0.0 1.0 0.0;
        0.0 0.0 1.0
    ]
    R = I3 + sin(θ) * K + (1 - cos(θ)) * K^2
    R * v
end


function rotate_rodrigues_vec(v::AbstractArray, n::AbstractVector, θ::AbstractFloat)
    if length(n) != 3
        error("normal axis must be a 3-vector")
    end
    n_norm = sqrt(sum(n.^2))
    n_unit = n / n_norm
    c = cos(θ)
    v * c + cross(n_unit, v) * sin(θ) + n_unit * dot(n_unit, v) * (1 - c)
end
