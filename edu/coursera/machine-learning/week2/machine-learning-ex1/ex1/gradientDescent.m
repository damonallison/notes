function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters)
%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESCENT(X, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

for iter = 1:num_iters

    % ====================== YOUR CODE HERE ====================== Instructions:
    % Perform a single gradient step on the parameter vector theta.
    %
    % Hint: While debugging, it can be useful to print out the values of the
    %       cost function (computeCost) and gradient here.
    %
    %
    % The way we "decend" is by taking the derivative (the slope) of our cost
    % function. The derivative will give us the direction to move toward. We
    % move a step in that direction. The size of the step is called the
    % `learning rate`.
    %
    % What is the partial derivative of J(Θ0, Θ1)?
    %
    % Gradient descent algorithm
    %
    % Repeat until convergence:
    % Θj := Θj - ⍺(deri)J(Θ0,Θ1)
    %
    %
    predictions = X * theta;
    der0 = (predictions - y).* X(:, 1);
    der1 = (predictions - y).* X(:, 2);

    t0 = theta(1, 1) - (alpha * (1/m) * sum(der0))
    t1 = theta(2, 1) - (alpha * (1/m) * sum(der1))

    theta = [t0; t1]

    % ============================================================

    % Save the cost J in every iteration
    J_history(iter) = computeCost(X, y, theta);

end

end
