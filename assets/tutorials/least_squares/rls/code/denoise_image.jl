# This file was generated, do not modify it. # hide
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