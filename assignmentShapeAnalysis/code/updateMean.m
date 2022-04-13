function mu = updateMean(alignedPointsets, normalize)
    mu = mean(alignedPointsets, 3);

    if normalize
        scale = norm(mu);
        mu = mu / scale;
    end

end
