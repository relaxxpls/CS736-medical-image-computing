%% Active Shape Models
clc; clear;
tic;

%% ---------- Reading ellipse data

PATH_RES = "../results/Q1/2/";
PATH_DATA = "../data/ellipses2D.mat";
data = load(PATH_DATA);
pointsets = data.pointSets;

% 300 ellipses each of 32 points each having 2 dimensions
[dims, numPts, numImgs] = size(pointsets);

%% PART D) plotting all the ellipses
figure;
hold on;

for i = 1:numImgs
    scatter(pointsets(1, :, i), pointsets(2, :, i), 6);
end

title("Unaligned Ellipse Pointsets");
hold off;
axis off;
axis equal;
saveas(gcf, PATH_RES + "d.png");

% ! We don't preshape / standardise the points in this approach
% %% ---------- Mean shape of ellipse data along with computed aligned pointsets

% preshapePointsets = toPreshape(pointsets);

% figure;
% hold on;

% for i = 1:numImgs
%     scatter(preshapePointsets(1, :, i), preshapePointsets(2, :, i), 6);
% end

% title("Aligned Ellipse Pointsets (Preshape Space)");
% hold off;
% axis off;
% axis equal;
% saveas(gcf, PATH_RES + "preshapePointsets.png");

%% ---------- Mean shape of ellipse data along with computed aligned pointsets

epsilon = 1e-8;
iterMax = 20;
[meanPointset, alignedPointsets] = Code22(pointsets, epsilon, iterMax);

figure;
hold on;

for i = 1:numImgs
    scatter(alignedPointsets(1, :, i), alignedPointsets(2, :, i), 6);
end

plot(meanPointset(1, :), meanPointset(2, :), 'LineWidth', 2);

title("Aligned Ellipse Pointsets with Mean Shape");
hold off;
axis off;
axis equal;

saveas(gcf, PATH_RES + "e.png");

%% ---------- Covariance matrix

[D, W] = eigenCalc(alignedPointsets);

figure;
plot(D);
title("Sorted Eigenvalues");
xlabel("Eigenvalue Number");
ylabel("Value");
saveas(gcf, PATH_RES + "eigenValues.png");

%% ---------- Top 3 Modes of variance

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
    hold off;
    axis off;
    axis equal;
    saveas(gcf, PATH_RES + "topVariance" + labels(i) + ".png");
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
hold off;
axis off;
axis equal;
saveas(gcf, PATH_RES + "pointsetClosest" + labels(1) + ".png");

% Closest to +3 stddev
minErrorPointset = findMinErrorPointset(alignedPointsets, meanPointset1);
figure
hold on
p0 = plot(meanPointset1(1, :), meanPointset1(2, :), "Color", "blue");
p1 = plot(minErrorPointset(1, :), minErrorPointset(2, :), "Color", "red");
title("Pointset closest to +3 stddev of top mode");
legend([p0, p1], "actual", "closest");
hold off;
axis off;
axis equal;
saveas(gcf, PATH_RES + "pointsetClosest" + labels(2) + ".png");

% Closest to -3 stddev
minErrorPointset = findMinErrorPointset(alignedPointsets, meanPointset2);
figure
hold on
p0 = plot(meanPointset2(1, :), meanPointset2(2, :), "Color", "blue");
p1 = plot(minErrorPointset(1, :), minErrorPointset(2, :), "Color", "red");
title("Pointset closest to -3 stddev of top mode");
legend([p0, p1], "actual", "closest");
hold off;
axis off;
axis equal;
saveas(gcf, PATH_RES + "pointsetClosest" + labels(3) + ".png");
