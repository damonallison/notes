%
% Normal Equation
%
% The normal equation solves linear regression without gradient descent.
%
% It's optimal for small data sets (up to ~10k features)
%
%

% x = [1, 2104, 5, 1, 45;
%      1, 1416, 3, 2, 40;
%      1, 1534, 3, 2, 30;
%      1, 852, 2, 1, 35;
%     ]

% y = [460; 432; 315; 178]

% training data
% x = [1 1; 1 2; 1 3]

% results
% y = [1, 2, 3]

% theta
% theta = [0 1]

function J = costFunction(X, y, theta)
    % X is the "design matrix" containing our training examples
    % y contains the labels

    m = size(X, 1);           % number of training examples
    predictions = X*theta;    % predictions of hypothesis on all m examples
    sqrErrors = (predictions - y).^2;  % squared errors

    J = 1/(2*m) * sum(sqrErrors);
end
