% Advanced Optimization
%
%

function [jVal, gradient] = costFunction(theta)
    % Assume:
    % J(theta) = (theta(1) - 5)^2 + (theta(2) - 5)^2

    jVal = (theta(1) - 5)^2 + (theta(2) - 5)^2;
    gradient = zeros(2, 1);
    gradient(1) = 2 * (theta(1) - 5);  % partial derivative
    gradient(2) = 2 * (theta(2) - 5);  % partial derivative
end

% tell fminunc we are giving it a cost function (gradient)
options = optimset('GradObj', 'on', 'MaxIter', 100);
initialTheta = zeros(2, 1)

% fminunc == function minimization unconstrained
%
% fminunc will find alpha for you. It will use the advanced gradient descent

[optTheta, functionVal, exitFlag] = fminunc(@costFunction, initialTheta, options)

