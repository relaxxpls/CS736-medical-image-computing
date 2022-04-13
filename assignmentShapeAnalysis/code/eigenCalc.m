function [D, W] = eigenCalc(pointsets)
    [dims, numPts, numImgs] = size(pointsets);

    flattened = reshape(pointsets, [dims * numPts, numImgs]);

    L = cov(flattened');
    [W, D] = eig(L);
    [D, idx] = sort(diag(D), 'descend');
    W = W(:, idx);
end
