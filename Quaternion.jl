#=
14 February 2021
Lior Sinai

Sources
- https://github.com/JuliaGeometry/Quaternions.jl
- julia/base/complex.jl

=#

"""
    Quaternion{T<:Real} <: Number

Quaternion number type with all units of `T`.
"""
struct Quaternion{T<:Real} <: Number
    s::T
    v1::T
    v2::T
    v3::T

end
const jm = Quaternion(false, false, true, false)
const km = Quaternion(false, false, false, true)

(::Type{Quaternion{T}})(x::Real) where {T} = Quaternion{T}(x, 0, 0, 0)                        #e.g. Quaternion{Int}(4)
(::Type{Quaternion{T}})(q::Quaternion{T}) where {T<:Real} = q                                 #e.g. Quaternion{Int}(q) where tyepof(q)=Quaternion{Int}
(::Type{Quaternion{T}})(q::Quaternion) where {T<:Real} = Quaternion{T}(q.s, q.v1, q.v2, q.v3) #e.g. Quaternion{Int}(q)

Quaternion(x::Real) = Quaternion(x, zero(x), zero(x), zero(x))
Quaternion(s::Real, v1::Real, v2::Real, v3::Real) = Quaternion(promote(s, v1, v2, v3)...)
Quaternion(s::Real, a::Vector) = Quaternion(s, a[1], a[2], a[3])
Quaternion(a::Vector) = Quaternion(0, a[1], a[2], a[3])

promote_rule(::Type{Quaternion{T}}, ::Type{S}) where {T<:Real,S<:Real} =
    Quaternion{promote_type(T,S)}

convert(::Type{Quaternion{T}}, q::Quaternion) where {T} =
    Quaternion(convert(T, q.s), convert(T, q.v1), convert(T, q.v2), convert(T, q.v3) )
convert(::Type{Quaternion{T}}, q::Quaternion{T}) where {T <: Real} = q

function show(io::IO, q::Quaternion)
    pm(x) = x < 0 ? " - $(-x)" : " + $x"
    print(io, q.s, pm(q.v1), "im", pm(q.v2), "jm", pm(q.v3), "km")
end


# -------------------- mathematical operations -------------------- #

conj(q::Quaternion) = Quaternion(q.s, -q.v1, -q.v2, -q.v3)
abs2(q::Quaternion) =     q.s * q.s + q.v1 * q.v1 + q.v2 * q.v2 + q.v3 * q.v3
abs(q::Quaternion) = sqrt(q.s * q.s + q.v1 * q.v1 + q.v2 * q.v2 + q.v3 * q.v3)

(+)(q::Quaternion, r::Quaternion) =
    Quaternion(q.s + r.s, q.v1 + r.v1, q.v2 + r.v2, q.v3 + r.v3)
(+)(q::Quaternion, x::Real) = Quaternion(q.s + x, q.v1, q.v2, q.v3)
(+)(x::Real, q::Quaternion) = Quaternion(q.s + x, q.v1, q.v2, q.v3)
(-)(q::Quaternion) = Quaternion(-q.s, -q.v1, -q.v2, -q.v3)
(-)(q::Quaternion, r::Quaternion) =
    Quaternion(q.s - r.s, q.v1 - r.v1, q.v2 - r.v2, q.v3 - r.v3)
(*)(q::Quaternion, r::Quaternion) = Quaternion(
        q.s * r.s - q.v1 * r.v1 - q.v2 * r.v2 - q.v3 * r.v3,
        q.s * r.v1 + q.v1 * r.s + q.v2 * r.v3 - q.v3 * r.v2,
        q.s * r.v2 - q.v1 * r.v3 + q.v2 * r.s + q.v3 * r.v1,
        q.s * r.v3 + q.v1 * r.v2 - q.v2 * r.v1 + q.v3 * r.s,
        )
(*)(q::Quaternion, x::Real) =   Quaternion(q.s * x, q.v1 * x, q.v2 *x, q.v3 *x)
(*)(x::Real, q::Quaternion, ) = Quaternion(q.s * x, q.v1 * x, q.v2 *x, q.v3 *x)
        
(/)(q::Quaternion, x::Real) = Quaternion(q.s / x, q.v1 / x, q.v2 / x, q.v3 / x)
inv(q::Quaternion) = conj(q) / abs2(q)
(/)(q::Quaternion, r::Quaternion) = q * inv(r)


#### --------------------- rotations --------------------- ####

function quat_axis_angle(n::AbstractVector, θ::AbstractFloat)
    if length(n) != 3
        error("normal axis must be a 3-vector")
    end
    n_norm = sqrt(sum(n.^2))
    Quaternion(cos(θ / 2), sin(θ / 2) * n / n_norm)
end


function rotate_quat(v::AbstractArray, n::AbstractVector, θ::AbstractFloat)
    q = quat_axis_angle(n, θ)
    rotate_quat(v, q)
end


function rotate_quat(v::Vector{T}, q::Quaternion) where T <: Real
    if !(abs2(q) ≈ 1)
        throw(ArgumentError("quaternion must be a of unit length"))
    end
    qrot = q * Quaternion(0, v) * conj(q)
    [qrot.v1; qrot.v2; qrot.v3]
end


function rotate_quat(V::AbstractMatrix{T}, q::Quaternion) where T <: Real
    if !(abs2(q) ≈ 1)
        throw(ArgumentError("quaternion must be a of unit length"))
    end
    R = quat_to_matrix(q)
    R * V
end


function quat_to_matrix(q::Quaternion)
    [
        1 - 2q.v2^2 - 2q.v3^2        2q.v1 * q.v2 - 2q.s * q.v3  2q.v1 * q.v3 + 2q.s * q.v2 ;
        2q.v1 * q.v2 + 2q.s * q.v3   1 - 2q.v1^2 - 2q.v3^2       2q.v2 * q.v3 - 2q.s * q.v1 ;
        2q.v1 * q.v3 - 2q.s * q.v2   2q.v2 * q.v3 + 2q.s * q.v1  1 - 2q.v1^2 - 2q.v2^2
    ]
end
