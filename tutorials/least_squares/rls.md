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
(minimizing $f(\x)$),
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

# Example Application: Image Denoising
Suppose we have a noisy image $\y$
and we want to clean it up.
One way to do this is by solving the following optimization problem:
\[
\xhat = \argmin{x} \frac{1}{2} \|\x - \y\|_2^2 + \frac{\beta}{2} \|\x\|_2^2,
\]
i.e., RLS with $\A = \I$.
In this case,
$\xhat$ is the cleaned up image.
The $\frac{1}{2} \|\x - \y\|_2^2$ term
tries to find an image that is close to the noisy image,
but the $\frac{\beta}{2} \|\x\|_2^2$ term
tries to prevent the cleaned up image
from keeping too much noise.

Normally,
we think of an image as a matrix of numbers,
so we'll first need to vectorize the image.
After finding $\xhat$,
we will reshape it into a matrix for display.

## Code
Let's see image denoising in action.
```julia:./code/denoise_image.jl
using LinearAlgebra: I
using Statistics: mean

function denoise_image(image::AbstractMatrix{<:Real}; β::Real = 1)
    image_mean = mean(image)
    image_zero_mean = image .- image_mean
    clean_vector = rls(I(length(image)), vec(image_zero_mean); β)
    clean_image = reshape(clean_vector, size(image)) .+ image_mean
    return clean_image
end

# Set up the true image
using Images: channelview, Gray, imresize
using TestImages: testimage
image_highres = Float64.(channelview(Gray.(testimage("peppers_gray"))))
image = imresize(image_highres, (64, 64))

# Add noise, then clean it up
using Random
Random.seed!(0)
noisy_image = image .+ 0.05 .* randn(size(image)...)
clean_image = denoise_image(noisy_image; β = 0.5)

# Display results
using Images: mosaicview, clamp01nan
mosaic = map(clamp01nan, mosaicview(image, noisy_image, clean_image; nrow = 1))
using Images: save # hide
save(joinpath(@OUTPUT, "denoise_image.png"), mosaic) # hide
```
\fig{./code/output/denoise_image}

The left image is the clean image,
the middle is the noisy image,
and the right is the denoised image.
We can see the right image has less variation
in pixel intensity
due to noise
than the middle image,
but the tradeoff is that the whole image seems
to have less dynamic range.
Personally,
I think the middle image looks better
than the one on the right,
but humans tend to be good
at seeing through noise,
so maybe the right image would be easier
for a computer to analyze.

# Exercises
1. Why did we subtract the image mean
   before applying RLS
   and then add it back after
   in `denoise_image`?
   What would happen if we didn't?
1. Come up with a more compelling example application
   for RLS with Tikhonov regularization.
   (In practice,
   one would use a much more sophisticated algorithm,
   likely involving a neural network,
   for image denoising.)

# FAQ
None yet!
