function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the X and Theta matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);


% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies x num_features matrix of movie features
%            where X(i, :) are the features for the ith movie.
%
%        Theta - num_users x num_features matrix of user features
%                where Theta(j, :) are user features for the jth user.
%
%        Y - num_movies x num_users matrix of user ratings of movies.
%            A `0` value for Y(i, j) means the ith movie was not rated by
%            the jth user.
%
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the
%            i-th movie was rated by the j-th user.
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the
%                     partial derivatives w.r.t. to each element of Theta
%

% 1. Implement the linear regression cost function.

% fprintf("printing matrix sizes:\n")
% size(X)
% size(Theta)
% size(Y)
% size(R)

%
% Multiplying by .* R effetively selects only the elements where R == 1.
% Thus, we only calculate the error for movies which have been rated.
%
J = sum(sum(((X * Theta' .* R) - Y) .^ 2)) / 2;

%
% Regularization
%
% Regularization sums each element .^ 2 of both Theta and X respectively.
%
% This penalizes both Theta and X (increases the overall cost) by a lambda
% amount. The higher the lambda value, the more bias (less variance /
% overfitting) we have in the model.
%
theta_reg = (lambda / 2) * sum(sum(Theta .^ 2));
x_reg = (lambda / 2) * sum(sum(X .^ 2));

J = J + theta_reg + x_reg;

% =============================================================

%
% The error matrix ((X * Theta' .* R) - Y) is the error for each
% recommendation where each row represents a user and each column represents a
% movie.
%
% Theta's rows represent the parameters for each user (j = 1 -> n), where the
% columns represent the movie. Thus multiplying error * theta will multiply the
% movie error by the movie's theta to give us the movie gradient.
%
X_grad = ((X * Theta' .* R) - Y) * Theta + (lambda * X);

%
% Transposing the error matrix makes each row the error for a movie and each
% column represents a user. Thus multiplying error' * X will multiply the
% movie error by each feature to give us the theta gradient.
%
Theta_grad = ((X * Theta' .* R) - Y)' * X + (lambda * Theta);

grad = [X_grad(:); Theta_grad(:)];

end
