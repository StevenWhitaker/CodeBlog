# This file was generated, do not modify it. # hide
using Plots
pyplot()
f̂(t) = â * t^2 + b̂ * t + ĉ
scatter(t, y, label = "Observed Data")
plot!(f, LinRange(0, 1, 101), label = "True Curve", line = (2, :red))
plot!(f̂, LinRange(0, 1, 101), label = "Estimated Curve", line = (2, :blue, :dash))
plot!(xlabel = "t", ylabel = "y")
savefig(joinpath(@OUTPUT, "fit_quadratic.svg")) # hide