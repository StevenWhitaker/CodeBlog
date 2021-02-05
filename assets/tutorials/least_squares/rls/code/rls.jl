# This file was generated, do not modify it. # hide
using LinearAlgebra: I

function ols(A::AbstractMatrix{<:Real}, y::AbstractVector{<:Real})
    x̂ = A \ y
    return x̂
end

function rls(A::AbstractMatrix{<:Real}, y::AbstractVector{<:Real}; β::Real = 1)
    Ã = [A; sqrt(β) * I]
    ỹ = [y; zeros(eltype(y), size(A, 2))]
    x̂ = ols(Ã, ỹ)
    return x̂
end