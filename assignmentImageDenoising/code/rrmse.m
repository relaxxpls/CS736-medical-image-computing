function R = rrmse(img1, img2)
    diff = abs(img1 - img2);
    N = diff.^2;
    D = img1.^2;
    R = sqrt(sum(N(:))) / sqrt(sum(D(:)));
end
