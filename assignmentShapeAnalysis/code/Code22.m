function [meanPointset, alignedPointsets] = Code22(pointsets, epsilon, iterMax)
    [~, ~, numImgs] = size(pointsets);

    alignedPointsets = pointsets;
    meanPointsetPrev = updateMean(pointsets, false);
    meanPointsetPrev = toPreshape(meanPointsetPrev);
    iter = 0;
    error = 1e6; % arbitrary large number

    while (iter < iterMax) && (error > epsilon)
        % 1) Align to the mean
        for i = 1:numImgs
            alignedPointsets(:, :, i) = Code2(meanPointsetPrev, alignedPointsets(:, :, i));
        end

        % 2) Update the mean and convert to preshape space
        meanPointset = updateMean(alignedPointsets, false);
        meanPointset = toPreshape(meanPointset);

        error = norm(meanPointset - meanPointsetPrev);
        meanPointsetPrev = meanPointset;
        iter = iter + 1;

        disp(['[Code22] Iterations ' num2str(iter) ', Error: ' num2str(error)]);
    end

    fprintf("Ran for %d steps\n", iter);
end
