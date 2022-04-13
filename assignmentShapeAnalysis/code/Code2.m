function alignedPointset = Code2(ref, p)
    [~, numPts] = size(ref);

    % Pre-processing, all Nx1
    x1_x = ref(1, :);
    x1_y = ref(2, :);
    x2_x = p(1, :);
    x2_y = p(2, :);

    % All 1x1, variables defined as specified in the paper
    ref = sum(x1_x(:));
    P = sum(x2_x(:));
    Y1 = sum(x1_y(:));
    Y2 = sum(x2_y(:));

    Z = sum(x2_x.^2 + x2_y.^2);

    C1 = sum((x1_x .* x2_x) + (x1_y .* x2_y));
    C2 = sum((x1_y .* x2_x) - (x1_x .* x2_y));

    W = numPts; % This is sum_{k} w_k of the weights which in this case we have assumed to be all 1

    % Solving the linear equations:
    A = [P -Y2 W 0; Y2 P 0 W; Z 0 P Y2; 0 Z -Y2 P]; % 4x4
    b = [ref; Y1; C1; C2]; % 4x1
    parameters = pinv(A) * b; % 4x1

    ax = parameters(1);
    ay = parameters(2);
    tx = parameters(3);
    ty = parameters(4);

    sR = [ax -ay; ay ax]; % The scaling+rotation matrix
    T = [tx; ty]; % The shift

    % Return the alignedPointset shape
    alignedPointset = sR * p + T;
end
