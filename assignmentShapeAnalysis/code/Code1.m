function alignedPointset = Code1(ref, p)
    [dims, numPts] = size(ref);
    W = eye(numPts);
    XWY = p * W * ref';
    [U, ~, V] = svd(XWY);
    R = V * U';

    % If det is -1, follow the results obtained by [S Umeyama 1991 IEEE, Kanatani 1994 IEEE TPAMI]
    if det(R) < 0
        corner = eye(dims);
        corner(dims, dims) = -1;
        R = V * corner * U';
    end

    alignedPointset = R * p;
end
