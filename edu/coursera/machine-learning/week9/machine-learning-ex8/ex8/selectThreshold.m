function [bestEpsilon bestF1] = selectThreshold(yval, pval)
%SELECTTHRESHOLD Find the best threshold (epsilon) to use for selecting
%outliers
%   [bestEpsilon bestF1] = SELECTTHRESHOLD(yval, pval) finds the best
%   threshold to use for selecting outliers based on the results from a
%   validation set (pval) and the ground truth (yval).
%

bestEpsilon = 0;
bestF1 = 0;
F1 = 0;

stepsize = (max(pval) - min(pval)) / 1000;
for epsilon = min(pval):stepsize:max(pval)

    % ====================== YOUR CODE HERE ======================
    % Instructions: Compute the F1 score of choosing epsilon as the
    %               threshold and place the value in F1. The code at the
    %               end of the loop will compare the F1 score for this
    %               choice of epsilon and set it to be the best epsilon if
    %               it is better than the current choice of epsilon.
    %
    % Note: You can use predictions = (pval < epsilon) to get a binary vector
    %       of 0's and 1's of the outlier predictions
%
% pval : The probability the example is *not* an anomaly.
%        Low probability examples are more likely an outlier.
%

% Using epsilon, find all of the:
%
% Term            Prediction  Actual
% True positive:  1           1
% False positive: 1           0
% True negative:  0           0
% False negative: 0           1
%
% Precision: true positive / true positive + false positive
% Recall : true positive / true positive + false negative
%
% F1 = (2 * precision * recall) / (precision + recall)

predictions = (pval < epsilon);

tp = sum((predictions == 1) & (yval == 1));
fp = sum((predictions == 1) & (yval == 0));
tn = sum((predictions == 0) & (yval == 0));
fn = sum((predictions == 0) & (yval == 1));

precision = tp / (tp + fp);
recall = tp / (tp + fn);

F1 = (2 * precision * recall) / (precision + recall);

    % =============================================================

    if F1 > bestF1
       bestF1 = F1;
       bestEpsilon = epsilon;
    end
end

end
