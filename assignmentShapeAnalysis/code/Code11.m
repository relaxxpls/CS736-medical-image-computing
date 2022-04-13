function [meanPointset, alignedPointsets] = Code11(pointsets, epsilon, iterMax)
    [~, ~, numImgs] = size(pointsets);

    alignedPointsets = pointsets;
    meanPointsetPrev = updateMean(alignedPointsets, true);
    iter = 0;
    error = 1e6; % arbitrary large number

    while (iter < iterMax) && (error > epsilon)
        % 1) Align to the mean
        alignedPointsets = toPreshape(alignedPointsets);

        for i = 1:numImgs
            alignedPointsets(:, :, i) = Code1(meanPointsetPrev, alignedPointsets(:, :, i));
        end

        % 2) Update the mean
        meanPointset = updateMean(alignedPointsets, true);

        error = norm(meanPointset - meanPointsetPrev);
        meanPointsetPrev = meanPointset;
        iter = iter + 1;

        disp(['[Code11] Iterations ' num2str(iter) ', Error: ' num2str(error)]);
    end

end
