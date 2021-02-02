# This file was generated, do not modify it. # hide
function fit_quadratic(t::AbstractVector{<:Real}, y::AbstractVector{<:Real})
    A = [t.^2 t ones(eltype(t), length(t))]
    (a, b, c) = ols(A, y)
    return (a, b, c)
end

using Random
Random.seed!(0)
(a, b, c) = (1, -1, 1//4) # True parameters
f(t) = a * t^2 + b * t + c
M = 50 # Number of observations
t = rand(M)
y = f.(t) .+ 0.01 .* randn(M) # Noisy observations
(â, b̂, ĉ) = fit_quadratic(t, y)