function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the
%   cost of using theta as the parameter for linear regression to fit the
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%

%
% err is the difference between  all predictions and actuals
%
err = (X * theta) - y;

%
% cost is the overall linear regression cost across all examples
%
cost = (1 / (2 * m)) * sum(err .^ 2);

%
% Regularization adds cost to parameters to "penalize" them, which helps prevent
% overfitting.
%
% Do *not* include theta(1) in regularization. We don't want to regularize the
% bias term.

temp = theta;
temp(1) = 0;

reg = (lambda / (2 * m)) * sum(temp .^ 2);

%
% J is the overall cost, including regularization
%
J = cost + reg;


%
% The partial derivative of regularized linear regression is
%
% (1/m) * sum((h(theta(x)) - y) * x) + ((lambda * theta) / m)
% Do *not* add a regularization term to theta(1). Gradient for theta(1) should
% *not* be regularized

grad = ((1/m) * (X' * err)) + ((lambda * temp) / m);

% =========================================================================

grad = grad(:);

end
