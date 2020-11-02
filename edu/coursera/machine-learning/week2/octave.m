% Octave test file
% MATLAB = MATrix LABratory

% Vectors

% 1x3 vector
v = [-2, -1, 0];

% 3x1 vector
v2 = [-2; -1; 0];

% graph vectors
plot(v, v2)

%% ------------------

% Unformly spaced vectors
% a:spacing:b
% linspace - specifying the number of points, octave computes spacing automatically.
% linspace(lower,upper,points)
a = 0
b = 100
c = a:10:b
c = linspace(0, 100, 10)

% Filtering vectors
v = [1, 2, 3, 4, 5];

% Returns a logical matrix (0s and 1s) for each element in the matrix.
v > 2
% Filters the matrix for only values matching
w = v(v > 2)

% Calculations w/ Vectors

% Elementwise operators. Performs the calculation for every element in a matrix.
%
% .*
% ./
% .^

v = [1, 2, 3];
w = 3*x.^2  % [3, 12, 27]

v = -20:0.1:20
w = 3*x.^2

% Vector Transpose

v = [1, -1, 8.5, 6, 19]
w = v';

% Line Plots (plot())

% Create vectors of x coords and y coords - both vectors must have the same number of elements.
%
% The 3rd parameter is for formatting.
%
% m:s    Magenta, dotted line, w/ square points
% g--*   Green, dashed line, with * markers
% r-     Red, solid line, with no markers
% r:o    Red, dotted line, circle points
%
% plot(x, y, 'm:s')
%
% Annotations
%
% plot(x, y)
% xlabel("x label")
% ylabel("y label")
% legend("series 1", "series 2")
% grid()
% annotation() % not sure how this is used

% Multiple plots
%
% plot(x, y, 'r:o')
% hold on        % Allows us to add additional plots
% plot(x2, y2, 'b:o')
