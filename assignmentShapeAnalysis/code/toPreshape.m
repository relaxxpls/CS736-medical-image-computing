function pointsets = toPreshape(pointsets)
    [~, numPts, numImgs] = size(pointsets);

    % center the shape at the origin
    centroids = sum(pointsets, 2) / numPts;
    pointsets = pointsets - centroids;

    % normalize
    for i = 1:numImgs
        pointsets(:, :, i) = pointsets(:, :, i) / norm(pointsets(:, :, i));
    end

end
