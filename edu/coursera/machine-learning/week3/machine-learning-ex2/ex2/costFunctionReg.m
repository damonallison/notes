function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters.

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta

predictions = sigmoid(X * theta);
errs = (-y .* log(predictions)) - ((1-y) .* log(1-predictions));

% Compute regularization: do *not* include theta(1) in regularization
reg = (lambda / (2 * m)) * sum((theta .^ 2)(2:size(theta, 1)));
J = ((1/m) * sum(errs)) + reg;


% Do *not* add a regularization term to theta(1). Gradient for theta(1) should
% *not* be regularized

temp = theta
temp(1) = 0

grad = ((1/m) * X' * (predictions - y)) + ((lambda * temp) / m)

% Non-vectorized gradient calculation

% g = sum((predictions - y) .* X(:, 1));
% grad(1) = (1/m) * g;

% for i = 2:size(theta)
%     g = sum((predictions - y) .* X(:, i));
%     reg = (lambda * theta(i)) / m;
%     grad(i) = ((1 / m) * g) + reg;
% end

% =============================================================

end
