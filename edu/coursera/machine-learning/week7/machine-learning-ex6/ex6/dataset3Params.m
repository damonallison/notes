function [C, sigma] = dataset3Params(X, y, Xval, yval)
%DATASET3PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = DATASET3PARAMS(X, y, Xval, yval) returns your choice of C and
%   sigma. You should complete this function to return the optimal C and
%   sigma based on a cross-validation set.
%

% You need to return the following variables correctly.
C = 1;
sigma = 0.3;

% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example,
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using
%        mean(double(predictions ~= yval))
%

options = [0.01; 0.03; 0.1; 0.3; 1; 3; 10; 30;];

%
% Store the results for all runs
%
% results(i, 1) == cost used
% results(i, 2) == sigma used
% results(i, 3) == error
results = [];

for i=1:length(options)
    cost = options(i);
    for j = 1:length(options)
        sigma = options(j);
        %
        % train model w/ C and sigma set to i, j respectively
        %
        model = svmTrain(X, y, cost, @(x1, x2) gaussianKernel(x1, x2, sigma));

        %
        % predict labels on cross validation set
        %
        predictions = svmPredict(model, Xval);

        %
        % find error
        %
        error = mean(double(predictions ~= yval));
        results = [results; cost sigma error];
        fprintf("Cost = %f Sigma = %f Error = %f\n", cost, sigma, error);
    end
end

%
% Find the minimum error
%
[min_error, row] = min(results(:, 3))

C = results(row, 1)
sigma = results(row, 2)

% =========================================================================

end
