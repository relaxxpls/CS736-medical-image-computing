%% MyMainScript
clc; clear;
tic;

%% Reading ellipse data
data = load('../data/ellipses2D.mat');
imgs = data.pointSets;

% 300 ellipses each of 32 points having 2 coorodinates
% [dims, numPts, numImgs] = size(imgs);
[dims, numPts, numImgs] = size(imgs);

% plotting all the ellipses
figure
hold on

for i = 1:numImgs
    scatter(imgs(1, :, i), imgs(2, :, i), 6);
end

title("Ellipses unaligned");
hold off
saveas(gcf, "../results/d.png")

%% Mean shape of ellipse data along with computed aligned pointsets

[meanPointset, alignedPointsets] = meanShape(imgs);

figure
hold on

for i = 1:numImgs
    scatter(alignedPointsets(1, :, i), alignedPointsets(2, :, i), 6);
end

plot(meanPointset(1, :), meanPointset(2, :));
title("Ellipse mean along with aligned pointsets");
hold off
saveas(gcf, "../results/e.png")

%% Eigenvalues calculation

[D, W] = eigenCalc(alignedPointsets);

figure
plot(D);
title("Plot of sorted eigenvalues");
saveas(gcf, "../results/eigenValues.png")

%% Top 3 modes of varations
labels = ["0", "+3 stddev", "-3 stddev"];

for i = 1:3
    meanPointset1 = meanPointset + 3 * sqrt(D(i)) * reshape(W(:, i), [2, numPts]);
    meanPointset2 = meanPointset - 3 * sqrt(D(i)) * reshape(W(:, i), [2, numPts]);

    figure
    hold on

    for j = 1:numImgs
        scatter(alignedPointsets(1, :, j), alignedPointsets(2, :, j), 6);
    end

    p0 = plot(meanPointset(1, :), meanPointset(2, :), "Color", "blue");
    p1 = plot(meanPointset1(1, :), meanPointset1(2, :), "Color", "red");
    p2 = plot(meanPointset2(1, :), meanPointset2(2, :), "Color", "green");

    title(["Modes of variation with eigenvalue " num2str(i)]);
    legend([p0, p1, p2], labels(1), labels(2), labels(3));
    hold off
    saveas(gcf, strcat("../results/topVariance", labels(i), ".png"))
end

%% Closest pointsets

meanPointset1 = meanPointset + 3 * sqrt(D(1)) * reshape(W(:, 1), [2, numPts]);
meanPointset2 = meanPointset - 3 * sqrt(D(1)) * reshape(W(:, 1), [2, numPts]);

% Closest to mean shape
minErrorPointset = findMinErrorPointset(alignedPointsets, meanPointset);
figure
hold on
p0 = plot(meanPointset(1, :), meanPointset(2, :), "Color", "blue");
p1 = plot(minErrorPointset(1, :), minErrorPointset(2, :), "Color", "red");
title("Pointset closest to mean shape");
legend([p0, p1], "actual", "closest");
hold off
saveas(gcf, strcat("../results/pointsetClosest", labels(1), ".png"))

% Closest to +3 stddev
minErrorPointset = findMinErrorPointset(alignedPointsets, meanPointset1);
figure
hold on
p0 = plot(meanPointset1(1, :), meanPointset1(2, :), "Color", "blue");
p1 = plot(minErrorPointset(1, :), minErrorPointset(2, :), "Color", "red");
title("Pointset closest to +3 stddev of top mode");
legend([p0, p1], "actual", "closest");
hold off
saveas(gcf, strcat("../results/pointsetClosest", labels(2), ".png"))

% Closest to -3 stddev
minErrorPointset = findMinErrorPointset(alignedPointsets, meanPointset2);
figure
hold on
p0 = plot(meanPointset2(1, :), meanPointset2(2, :), "Color", "blue");
p1 = plot(minErrorPointset(1, :), minErrorPointset(2, :), "Color", "red");
title("Pointset closest to -3 stddev of top mode");
legend([p0, p1], "actual", "closest");
hold off
saveas(gcf, strcat("../results/pointsetClosest", labels(3), ".png"))
