#=
14 February 2021
Lior Sinai

Sources
- https://github.com/JuliaGeometry/Quaternions.jl

=#
module Rotations

import Base: convert, show
import Base: +, -, *, /, ^
import Base: conj, abs, abs2, inv

export Quaternion, 
       rotate2d,
       rotate3d,
       R_TaitBryan,
       rotate_TaitBryan,
       rotate_rodrigues,
       rotate_rodrigues_vec,
       rotate_quat,
       quat_to_matrix,
       quat_axis_angle,
       rotate_pauli

       
include("rotate.jl")
include("Quaternion.jl")
include("rodrigues.jl")
include("taitBryan.jl")
include("pauli.jl")

end