#### --------------------- Pauli Matrices --------------------- ####

function pauli(v::AbstractArray)
    if length(v) != 3
        error("v must be a 3-vector")
    end
    [
        v[3]+0im      v[1]-v[2]*im;
        v[1]+v[2]*im  -v[3]+0im
    ]
end


function inv_pauli(σv::AbstractArray)
    if size(σv) != (2, 2)
        error("σv must be a 2×2 matrix")
    end
    [real(σv[2][1]); imag(σv[2][1]); real(σv[1][1])]
end


function rotate_pauli(v::AbstractArray, n::AbstractVector, θ::AbstractFloat)
    if length(n) != 3
        error("normal axis must be a 3-vector")
    end
    n_norm = sqrt(sum(n.^2))
    n_unit = n / n_norm
    I2 = [
        1.0 0.0;
        0.0 1.0
    ]
    U = cos(θ/2) * I2 - sin(θ/2) * im * pauli(n_unit)
    UT = conj.(transpose(U))
    σv = U * pauli(v) * UT 
    inv_pauli(σv)
end