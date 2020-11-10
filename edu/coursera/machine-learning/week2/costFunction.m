%
% Normal Equation
%
% The normal equation solves linear regression without gradient descent.
%
% It's optimal for small data sets (up to ~10k features)
%
%

% y = [460; 432; 315; 178]

% theta
% theta = [0 1]

function J = costFunction(X, y, theta)
    % X is the "design matrix" containing our training examples
    %
    % X = [1, 2104, 5, 1, 45;
    %      1, 1416, 3, 2, 40;
    %      1, 1534, 3, 2, 30;
    %      1, 852, 2, 1, 35]
    %
    % y contains labels
    % y = [460; 432; 315; 178]
    %
    % theta is the row vector of the current parameter values.
    %
    % Returns the total cost in terms of sum of square error between the
    % hypothesis values (X * theta) and the actual values (y)

    m = size(X, 1);                    % number of training examples
    predictions = X*theta;             % predictions of hypothesis on all m examples
    sqrErrors = (predictions - y).^2;  % squared errors

    J = 1/(2*m) * sum(sqrErrors);
end
