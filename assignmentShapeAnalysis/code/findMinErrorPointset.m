function closestPointset = findMinErrorPointset(pointsets, targetPointset)
    [dims, numPts, numImgs] = size(pointsets);
    closestPointset = zeros(dims, numPts);
    minError = 1e6; % set to a large number

    for i = 1:numImgs
        diff = abs(targetPointset - pointsets(:, :, i)).^2;
        error = sum(diff(:)) / numel(targetPointset);

        if (error < minError)
            minError = error;
            closestPointset = pointsets(:, :, i);
        end

    end

end
