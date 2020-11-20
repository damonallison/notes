function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices.
%
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% You need to return the following variables correctly
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

% X contains 5000 rows of 400 pixels each.
%
% Theta1 contains the weights to apply to each of the 400 pixels (and 1 bias
% unit) to produce each neurons in a2. Therefore, we transpose theta and
% multiply X, which gives us the values of each a2 node.

a1 = [ones(m, 1) X];
% fprintf("size(a1) == %d %d\n", size(a1, 1), size(a1, 2));
% fprintf("size(t1) == %d %d\n", size(Theta1, 1), size(Theta1, 2));
a2 = sigmoid(Theta1 * a1');
% fprintf("size(a2) == %d %d\n", size(a2, 1), size(a2, 2));
a2 = [ones(m, 1) a2'];
% fprintf("size(a2) == %d %d\n", size(a2, 1), size(a2, 2));
% fprintf("size(t2) == %d %d\n", size(Theta2, 1), size(Theta2, 2));

% We then repeat the process with a2 and theta2 to produce a3.

z3 = sigmoid(Theta2 * a2');
% fprintf("size(z3) == %d %d\n", size(z3, 1), size(z3, 2));

% We now have the values for each example in X for output neuron (K).
%
% To find the overall cost, we apply logistic regression for each example and
% each output class.

% Recode y values as k * m row vectors.
yk = zeros(num_labels, m);
for i=1:m
    yk(y(i), i) = 1;
end
% fprintf("size(yk) == %d %d\n", size(yk, 1), size(yk, 2));

J = (1/m) * (sum ( sum ( (-yk) .* log(z3) - (1 - yk) .* log(1 - z3) ) ) );

% regularization: do *not* include the bias term (first column)
t1 = Theta1(:, 2:size(Theta1, 2));
t2 = Theta2(:, 2:size(Theta2, 2));

regularization = lambda * (sum ( sum (t1 .^ 2)) + sum ( sum (t2 .^ 2) ) ) / (2*m);

J = J + regularization;

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

for t=1:m

    %
    % Step 1
    %
    % Run a "forward pass" (feeedforward) to compute all neuron
    % activations, including the final values (i.e., h(theta))
    %
    a1 = X(t, :);
    a1 = [1 a1]; % add bias

    % Layer 2
    z2 = Theta1 * a1';
    a2 = sigmoid(z2);
    a2 = [1; a2]; % add bias

    % Layer 3
    %
    % a3 = The values for each output class. i.e., h(theta) for each k. (size == [k 1])
    z3 = Theta2 * a2;
    a3 = sigmoid(z3);


    %
    % Step 2
    %
    % Compute the error for layer 3.
    %
    actual_y = yk(:, t); % the label vector for the t'th training example size == [k 1]
    delta3 = a3 - actual_y;
    z2 = [1; z2];

    %
    % Step 3.
    %
    % Compute the error for layer 2.
    %
    delta2 = (Theta2' * delta3) .* sigmoidGradient(z2);
    delta2 = delta2(2:end); % remove the bias error

    Theta2_grad = Theta2_grad + delta3 * a2';
    Theta1_grad = Theta1_grad + delta2 * a1;
end

% Gradients w/o regularization
% Theta1_grad = Theta1_grad / m;
% Theta2_grad = Theta2_grad / m;

% Do *not* regularize the bias term
Theta1_grad(:, 1) = Theta1_grad(:, 1) ./ m;
Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) ./ m + ((lambda / m) * Theta1(:, 2:end));

Theta2_grad(:, 1) = Theta2_grad(:, 1) ./ m;
Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) ./ m + ((lambda / m) * Theta2(:, 2:end));

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
