function [J] = possibi_cost(X, U, theta, q, eta)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION (auxiliary)
%  [J] = possibi_cost(X, U, theta, q, eta)
% Computes the value of the cost function for a possibilistic clustering
% algorithm, where the squared Euclidean distance is used. The cost
% function incorporates two terms: the first measures the weighted
% compatibility of data vectors with clusters, and the second penalizes
% deviations from strict membership. The function can be used to evaluate
% the quality of a solution during optimization.
%
% INPUT ARGUMENTS:
%  X:       lxN matrix, each column of which corresponds to a data vector.
%           The dataset to be clustered.
%  U:       Nxm matrix, whose (i,j) element denotes the compatibility of 
%           the i-th data vector with the j-th cluster.
%  theta:   lxm matrix, each column of which corresponds to a cluster
%           representative (e.g., cluster center).
%  q:       A scalar exponent (fuzziness parameter) controlling the
%           weighting of the memberships in the cost function. Must be 
%           positive.
%  eta:     m-dimensional array of the penalty parameters associated with
%           the clusters. Higher values of eta encourage stricter
%           clustering behaviors.
%
% OUTPUT ARGUMENTS:
%  J:       Scalar value representing the cost function. Lower values
%           indicate better clustering performance in the context of the
%           given model.
%
% DETAILS:
%  The cost function is computed as:
%    J = sum_{i=1}^N sum_{j=1}^m U(i, j)^q * d(x_i, theta_j)
%        + sum_{j=1}^m eta(j) * sum_{i=1}^N (1 - U(i, j))^q
%  where d(x_i, theta_j) is the squared Euclidean distance between data
%  vector x_i and cluster representative theta_j.
%
%  The first term rewards strong memberships for points close to cluster
%  centers, while the second term penalizes weak memberships.
%
% NOTES:
%  - This function assumes the squared Euclidean distance is computed 
%    through an external function `distan(x, y)` which returns the 
%    squared norm of the difference (x - y).
%  - The matrix dimensions are expected to match as follows:
%    * X: lxN, U: Nxm, theta: lxm, eta: mx1.
%  - The value of `q` must be > 0 for the algorithm to function correctly.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N, m] = size(U);

first_term = 0;
for i = 1:N
    for j = 1:m
        d = distan(X(:, i), theta(:, j));
        first_term = first_term + (U(i, j)^q * d);
    end
end

second_term = 0;
for j = 1:m
    inner = 0;
    for i = 1:N
        inner = inner + (1 - U(i, j))^q;
    end
    second_term = second_term + (eta(j) * inner);
end

J = first_term + second_term;