@def title = "Regularized Least Squares"
@def tags = ["optimization", "least squares", "regularized least squares"]

\toc

# What is Regularized Least Squares?
Regularized least squares (RLS)
is ordinary least squares (OLS) but with an extra regularization term.
Described as an optimization problem,
RLS solves
\[
\xhat = \argmin{\x} f(\x) + \beta R(\x).
\]
As in OLS,
$f(\x) = \frac{1}{2} \|\A \x - \y\|_2^2$,
with $\x \in \reals^N$, $\A \in \reals^{M \times N}$, and $\y \in \reals^M$.
Unlike OLS, in RLS we are also trying to minimize the regularizer $R(\x)$.
The regularization parameter $\beta > 0$
is a user-controlled parameter that
controls the relative importance of minimizing $R(\x)$ versus $f(\x)$;
the smaller $\beta$ is,
the more emphasis is placed on minimizing $f(\x)$,
and the larger $\beta$ is,
the more emphasis is placed on minimizing $R(\x)$.

# Tikhonov Regularization
The most common choice of regularizer is called Tikhonov regularization,
where
\[
R(\x) = \frac{1}{2} \|\x\|_2^2.
\]
In RLS with Tikhonov regularization,
we want to find $\xhat$ such that $\A\xhat$ is close to $\y$
(minimizing $f(\x)$,
but at the same time
we don't want the elements of $\xhat$ to be too large
(minimizing $R(\x)$).

# RLS Solution: Tikhonov Regularization
RLS with Tikhonov regularization is actually OLS in disguise,
so we can use the solution to OLS.
To do so,
we need to rewrite the function we want to minimize
so that it looks like OLS.
We can do so as follows
(in the following,
$\I$ is the identity matrix,
and $\zeros$ is a vector of all zeros):
\begin{align}
f(\x) + \beta R(\x) &= \frac{1}{2} \|\A\x - \y\|_2^2 + \frac{\beta}{2} \|\x\|_2^2 \\
&= \frac{1}{2} \sum_{i = 1}^M ([\A\x]_i - y_i)^2 + \frac{\beta}{2} \sum_{j = 1}^N x_j^2 \\
&= \frac{1}{2} \sum_{i = 1}^M ([\A\x]_i - y_i)^2 + \frac{1}{2} \sum_{j = 1}^N ([\sqrt{\beta}\I\x]_j - 0)^2 \\
&= \frac{1}{2} \sum_{i = 1}^{M + N} \left(\begin{bmatrix} \A\x \\ \sqrt{\beta}\I\x \end{bmatrix}_i - \begin{bmatrix} \y \\ \zeros \end{bmatrix}_i\right)^2 \\
&= \frac{1}{2} \sum_{i = 1}^{M + N} ([\tilde{\A}\x]_i - \tilde{y}_i)^2 \\
&= \frac{1}{2} \|\tilde{\A}\x - \tilde{\y}\|_2^2 \\
\end{align}
Now we see that RLS with Tikhonov regularization
is the same as OLS with
\[
\tilde{\A} = \begin{bmatrix} \A \\ \sqrt{\beta} \I \end{bmatrix}
\]
instead of just $\A$, and
\[
\tilde{\y} = \begin{bmatrix} \y \\ \zeros \end{bmatrix}
\]
instead of just $\y$.

# Solving RLS with Tikhonov Regularization in Julia
Solving RLS with Tikhonov regularization in Julia
is as simple as calling `ols` with $\tilde{\A}$ and $\tilde{\y}$.
```julia:./code/rls.jl
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
```

# Example Application: Ridge Regression

# Exercises

# FAQ
