
function R_TaitBryan(;yaw::Real, pitch::Real, roll::Real) 
    yaw, pitch, roll = promote(yaw, pitch, roll)
    c = cos(yaw)
    s = sin(yaw)
    Rψ = [
        1.0  0.0  0.0;
        0.0  c    -s;
        0.0  s    c
    ]
    c = cos(pitch)
    s = sin(pitch)
    Rθ = [
         c  0.0  s;
         0. 1.0  0.0;
        -s  0.0  c
    ]
    c = cos(roll)
    s = sin(roll)
    Rφ = [
        c    -s   0.0; 
        s    c    0.0; 
        0.0  0.0  1.0
    ]
    R =  Rφ * Rθ *  Rψ 
    R
end


function rotate_TaitBryan(v::AbstractMatrix{T}; yaw::Real, pitch::Real, roll::Real) where T <: Real    
    R = R_TaitBryan(yaw=yaw, pitch=pitch, roll=roll) 
    R * v
end