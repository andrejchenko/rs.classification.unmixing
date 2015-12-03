function Y = removeNoise(Y)
    noise_hat = estNoise(Y);
    Y = Y-noise_hat;
    clear noise_hat
end
