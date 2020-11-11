
function [jVal, gradient] = costFunction(theta)
    jVal = % new cost function (w / regularization term)
    gradient(1) =  % gradient zero (doesn't include regularization)
    gradient(2+) = % gradient (includes regularization) ((derivative) + (regularization cost)
end
