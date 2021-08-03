@def title = "Gradient Descent"
@def tags = ["optimization", "least squares", "gradient descent"]

\toc

# What is Gradient Descent?
Gradient descent (GD)
is an iterative algorithm
for minimizing functions,
i.e., solving
\[
\xhat = \argmin{\x} f(\x).
\]
We start with an initial guess $\x_0$,
and at each iteration
we try to get closer
to the true minimizer $\xhat$
by utilizing the gradient
of our cost function $\nabla f(\x)$.
Specifically,
GD consists of the following steps:
1. Specify $\x_0$ and a step size $\alpha > 0$.
2. For the $k$th iteration
   (starting at $k = 1$),
   update $\x$ as
   \[
   \x_k = \x_{k-1} - \alpha \nabla f(\x_{k-1}).
   \]
3. Repeatedly update $\x$
   until some stopping criterion is met
   (e.g., $\nabla f(\x_k) \approx \zeros$
   or a certain user-specified number of iterations has passed).
Under certain conditions on $f$ and $\alpha$,
GD is guaranteed to converge
to the minimizer
(or a minimizer, if there is more than one)
of $f$.

# GD for (Regularized) Least Squares
Explain why use GD when one could use pseudoinverse.

# Implementing GD for RLS in Julia

# Example Application: Magnetic Resonance Imaging

## Code

# Exercises

# FAQ

