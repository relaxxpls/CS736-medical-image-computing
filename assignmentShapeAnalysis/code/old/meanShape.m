function [meanPointset, alignedPointsets] = meanShape(pointsets)
    [dims, numPts, numImgs] = size(pointsets);

    % shift centroid of shape to origin
    centroids = sum(pointsets, 2) / numPts;
    centroids = repmat(centroids, [1, numPts, 1]);
    pointsets = pointsets - centroids;

    % normalize
    for i = 1:numImgs
        pointsets(:, :, i) = pointsets(:, :, i) / norm(pointsets(:, :, i));
    end

    meanPointset = pointsets(:, :, 1);

    % gradient descent
    epsilon = 1e-6;
    error = 1000;

    while (error < epsilon)
        meanPointsetOld = meanPointset;
        % Optimum rotation
        for i = 1:numImgs
            [U, ~, V] = svd(meanPointset * pointsets(:, :, i)');
            R = V * U';
            d = det(R);

            if (d == -1)
                I = eye(dims);
                I(dims, dims) = -1;
                R = V * I * U';
            end

            pointsets(:, :, i) = R' * pointsets(:, :, i);
        end

        meanPointset = sum(pointsets, 3) / numImgs;
        meanPointset = meanPointset / norm(meanPointset);
        error = norm(meanPointset - meanPointsetOld);
    end

    alignedPointsets = pointsets;
end
