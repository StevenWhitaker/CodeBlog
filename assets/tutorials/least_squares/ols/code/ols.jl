# This file was generated, do not modify it. # hide
function ols(A::AbstractMatrix{<:Real}, y::AbstractVector{<:Real})
    x̂ = A \ y
    return x̂
end