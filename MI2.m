function selected_features = MI2(features, labels, Q,nn)
    % MI - Mutual Information Feature Selection
   
    % Inputs:
    %   features - Matrix of size (n_samples x n_features), where each row is a sample and each column is a feature.
    %   labels   - Column vector of size (n_samples x 1), with the class labels for each sample.
    %   Q        - Number of top features to select based on mutual information.
    
    % Outputs:
    %   selected_features - Indices of the selected features with the highest mutual information scores.

    % Number of features
    [~, n_features] = size(features);

    % Initialize vector to store mutual information scores
    mi_scores = zeros(1, n_features);

    % Calculate mutual information for each feature with respect to the labels
    for i = 1:n_features
        
        mi_scores(i) = mutual_info(features(:, i), labels,nn);

    end

    % Sort features by MI scores in descending order and select the top Q features
    [k, sorted_indices] = sort(mi_scores, 'descend');
    selected_features = sorted_indices(1:Q);
end

