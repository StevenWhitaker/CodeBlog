@def title = "Ordinary Least Squares"
@def tags = ["optimization", "least squares", "ordinary least squares", "pseudoinverse"]

\toc

# What is Ordinary Least Squares?
Ordinary least squares (OLS), or simply least squares,
seeks to find a vector $\xhat \in \reals^N$ that,
after being multiplied by a matrix $\A \in \reals^{M \times N}$,
minimizes the distance to another vector $\y \in \reals^M$.
In math, OLS seeks to solve the following optimization problem:
\[
\xhat = \argmin{\x} f(\x), \qquad f(\x) = \frac{1}{2} \|\A\x - \y\|_2^2,
\]
where
$\|\x\|_2^2 = \x'\x = \sum_{i = 1}^N x_i^2$,
and
$\x'$ is the transpose of $\x$.

Taking a systems perspective,
$\A$ could characterize a linear system,
$\y$ could be observed data from that system,
and $\xhat$ would then be the most likely input
that caused $\y$.

# OLS Solution
The solution to (1) is straightforward:
\[
\xhat = \A^+ \y,
\]
where
$\A^+$ is the pseudoinverse of $\A$.

# Solving OLS in Julia
Solving OLS problems in Julia is likewise easy,
and can be done with the following function.
```julia:./code/ols.jl
function ols(A::AbstractMatrix{<:Real}, y::AbstractVector{<:Real})
    x̂ = A \ y
    return x̂
end
```

# Example Application: Fitting a Quadratic Function to Noisy Data
Suppose we have data $\y$ that contains noisy observations
from an unknown function
that we suspect is quadratic.
Further suppose that we know at what time each observation in $\y$ was acquired
(so $y_i$ was acquired at time $t_i$).
We can use OLS to fit a quadratic function of time to the data.
Each data point $y_i$ can be modeled as being
approximately equal to $a \cdot t_i^2 + b \cdot t_i + c$.
We can use this model to specify what $\A$ and $\x$ are.
In this case, $a$, $b$, and $c$ are unknown,
but we want to determine what they are;
therefore, $\x = [a, b, c]'$.
Then $\A$ must contain the $t_i$'s:
\[
\begin{bmatrix}
t_1^2 & t_1 & 1 \\
& \vdots & \\
t_M^2 & t_M & 1 \\
\end{bmatrix}.
\]
(If you're not convinced this is correct,
take one of the rows of $\A$ and multiply it by $\x$
and see how it compares to our model for $y_i$.)

## Code
Now let's put it all together in code.
```julia:./code/fit_quadratic.jl
function fit_quadratic(t::AbstractVector{<:Real}, y::AbstractVector{<:Real})
    A = [t.^2 t ones(eltype(t), length(t))]
    (â, b̂, ĉ) = ols(A, y)
    return (â, b̂, ĉ)
end

using Random
Random.seed!(0)
(a, b, c) = (1, -1, 1//4) # True parameters
f(t) = a * t^2 + b * t + c
M = 50 # Number of observations
t = rand(M)
y = f.(t) .+ 0.01 .* randn(M) # Noisy observations
(â, b̂, ĉ) = fit_quadratic(t, y)
```

Let's see how the estimated parameters compare to the true parameters.
```julia:./code/fit_quadratic_show_parameters.jl
#hideall
using Printf
@printf("(a, b, c) = (%0.3f, %0.3f, %0.3f)\n", a, b, c)
@printf("(â, b̂, ĉ) = (%0.3f, %0.3f, %0.3f)\n", â, b̂, ĉ)
```
\output{./code/fit_quadratic_show_parameters.jl}

The estimated parameters agree pretty well with the true values!
Let's visualize how our quadratic fit compares to the noisy data
and to the underlying true quadratic curve.
```julia:./code/fit_quadratic_plots.jl
using Plots
pyplot()
f̂(t) = â * t^2 + b̂ * t + ĉ
scatter(t, y, label = "Observed Data")
plot!(f, LinRange(0, 1, 101), label = "True Curve", line = (2, :red))
plot!(f̂, LinRange(0, 1, 101), label = "Estimated Curve", line = (2, :blue, :dash))
plot!(xlabel = "t", ylabel = "y")
savefig(joinpath(@OUTPUT, "fit_quadratic.svg")) # hide
```
\fig{./code/output/fit_quadratic}

As expected from how close our estimated parameters
were to the true parameters,
our predicted quadratic curve almost exactly coincides
with the true quadratic curve
that produced the observed measurements.

# Exercises
1. Write a function to fit a cubic curve to noisy data.
   A cubic function has the form $a \cdot t^3 + b \cdot t^2 + c \cdot t + d$.
   *Hint: It will look very similar to* `fit_quadratic`.
1. Write a function to fit a polynomial of degree $d$ to noisy data.
   A polynomial function of degree $d$ has the form $\sum_{i = 0}^d c_i \cdot t^i$.
   (Comparing to the quadratic case, $d = 2$, $c_2 = a$, $c_1 = b$, and $c_0 = c$.)
   Allow the caller to specify what degree to use.
1. Suppose you have the system of equations shown in equation (4) below.
   Use `ols` to solve this system for $x_1$ and $x_2$.
   (The solution is $(x_1, x_2) = (1, 2)$.)
\begin{align}
x_1 + 2x_2 &= 5 \\
x_1 + 3x_2 &= 7
\end{align}

# FAQ
**Where does $\A$ come from? How do we know what it is?**
---
Generally, $\A$ either comes from data, in which case
finding $\A$ is simply a matter of reading data from a file,
or $\A$ models a system that transforms inputs $\x$ into outputs $\y$.
In this latter case,
determining $\A$ boils down to learning about the system you want to model
and then converting the physics and/or assumptions
into matrix form.
In the quadratic fitting example,
we had to create $\A$ ourselves,
and we did so by using our knowledge of quadratic functions
and how they map inputs to outputs.
As another example,
in magnetic resonance imaging (MRI)
the system matrix $\A$ corresponds to
the discrete fourier transform (DFT) matrix;
again, determining $\A$ came from
understanding MRI physics and then converting it into matrix form.
