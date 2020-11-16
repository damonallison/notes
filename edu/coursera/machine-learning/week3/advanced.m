function [jVal, gradient] = costFunction(theta)
    % Assume:
    % J(theta) = (theta(1) - 5)^2 + (theta(2) - 5)^2

    jVal = (theta(1) - 5)^2 + (theta(2) - 5)^2;
    gradient = zeros(2, 1);
    gradient(1) = 2 * (theta(1) - 5);  % partial derivative
    gradient(2) = 2 * (theta(2) - 5);  % partial derivative
end
% Advanced Optimization
%
% fminunc (function minimization unconstrained) will automatically determine the
% minimum value of a function with potentially multiple variables.
%
% It will find the values of theta for you using advanced gradient descent.

% tell fminunc we are giving it a cost function (gradient)
options = optimset('GradObj', 'on', 'MaxIter', 100);
[optTheta, functionVal, exitFlag] = fminunc(@costFunction, zeros(2, 1), options)

