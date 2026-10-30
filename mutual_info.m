function mi = mutual_info(X, Y,nn)
    % MUTUAL_INFO - Calculates the mutual information between two variables
    % X and Y are vectors of the same length.
    
    % Number of bins for discretization
    num_bins = nn;

    % Define bin edges based on the min and max of X and Y
    X_edges = linspace(min(X), max(X), num_bins + 1);
    Y_edges = linspace(min(Y), max(Y), num_bins + 1);

    % Joint histogram with specified edges
    joint_hist = histcounts2(X, Y, X_edges, Y_edges);
    joint_prob = joint_hist / sum(joint_hist(:));

    % Marginal histograms
    X_hist = sum(joint_hist, 2) / sum(joint_hist(:));
    Y_hist = sum(joint_hist, 1) / sum(joint_hist(:));

    % Calculate mutual information
    mi = 0;
    for i = 1:num_bins
        for j = 1:num_bins
            if joint_prob(i, j) > 0
                mi = mi + joint_prob(i, j) * log2(joint_prob(i, j) / (X_hist(i) * Y_hist(j)));
            end
        end
    end
end
