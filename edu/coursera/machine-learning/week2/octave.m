% Octave test file
% MATLAB = MATrix LABratory
%
%
% Determine if a variable name is in use / where it is used.
% which [name]

% -----------------------------------------------------------------------------
% Creating Matrices
% -----------------------------------------------------------------------------

% 1x3 vector
v = [-2, -1, 0];

% 3x1 vector
v2 = [-2; -1; 0];

%
% Matrix creation functions
%

% Creating uniformly spaced vectors
%
% a:spacing:b
%
% If the upper bound does not fall on a multiple of spacing, is it omitted.
a = 0
b = 100
c = a:10:b

%
% linspace - specifying the number of points, octave computes spacing automatically.
% linspace(lower,upper,points)

c = linspace(0, 100, 3)

%
% Special creation functions
%
eye(2)
zeros(2, 5)
ones(2, 5)
rand(2, 10)

% -----------------------------------------------------------------------------
% Matrix size and length
%
% length() returns the size of the largest dimension (rows or columns).
%
% Use length() with vectors
%
% l = length(m)
%
% size() returns both dimensions.
%
% Use size() with matrices.
%
% [nrows, ncols] = size(m)
% -----------------------------------------------------------------------------

v = [1, 2, 3; 4, 5, 6]

length(v) % returns the length of the largest dimension (rows or columns)
[nrows, ncols] = size(v);

% -----------------------------------------------------------------------------
% Concatenating Matrices
% -----------------------------------------------------------------------------

m1 = [1, 2, 3]
m2 = [4, 5, 6; 7, 8 , 9]

% Vertical Concatenation (;). Matrices must have the same number of columns.
m3 = [m1; m2]

% Horiztontal Concatenation (,). Matrices must have the same number of rows.
m4 = [m1, m2]

% -----------------------------------------------------------------------------
% Reshaping Arrays
%
% Rows are filled in first, then columns
% -----------------------------------------------------------------------------

v = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
v2 = reshape(v, 5, 2)  % 5 rows, 2 columns
% v2 = [1, 2; 3, 4;, 5, 6; 7, 8; 9, 10]

% "vectorize" - create a single vector from a matrix
v = v2(:);


% -----------------------------------------------------------------------------
% Filtering
% -----------------------------------------------------------------------------

v = [1, 2, 3, 4, 5];

% Returns a logical matrix (0s and 1s) for each element in the matrix.
v > 2
% Filters the matrix for only values matching
w = v(v > 2)

% -----------------------------------------------------------------------------
% Accessing a matrix
% -----------------------------------------------------------------------------

% Retrieving multiple rows / columns
m = [1, 2, 3; 4, 5, 6; 7, 8, 9]

% Return all row / column combinations
% From rows [1, 3], return cols [2, 3]
rows = [1, 3]
cols = 2:3;
m(rows, cols) % [2, 3; 8, 9]

% A single colon references all elements in that dimension.

m(:, 1) % retrieves all rows, column 1
m(1, :) % retrieves row 1, all columns

% -----------------------------------------------------------------------------
% Matrix Calculations
% -----------------------------------------------------------------------------

% Scalar operations

v * 1.5
v - 1.5

v = v + v
v = v - v

% Elementwise operators. Performs the calculation for every element in a matrix.
%
% Matricies must be of the same size
% .*
% ./
% .^

v = [1, 2, 3];
w = 3*v.^2  % [3, 12, 27]

v = -20:0.1:20
w = 3*v.^2

% -----------------------------------------------------------------------------
% Matrix Multiplication
%
% The number of columns in the first matrix must match the number of rows in
% the second matrix.
% -----------------------------------------------------------------------------

v = [1, 2, 3]
v2 = [1, 2; 3, 4; 5, 6]

v * v2

% -----------------------------------------------------------------------------
% Statistics
% -----------------------------------------------------------------------------

v = [1, 2, 3; 4, 5, 6; 7, 8, 9]

mean(v)         % Average for each column (not row)
mean(scores, 2) % Average on the second dimension (the row)
mean(scores(:)) % Vectorizes the entire matrix, then takes mean.


% -----------------------------------------------------------------------------
% Transposing
% -----------------------------------------------------------------------------

v = [1, -1, 8.5, 6, 19]
w = v';


% -----------------------------------------------------------------------------
% Plotting
% -----------------------------------------------------------------------------

v = [1, 2, 3]
v2 = [4, 5, 6]
plot(v, v2)

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

% -----------------------------------------------------------------------------
% Programming Language
%
% & == and
% | == or
% ~ == not
% -----------------------------------------------------------------------------

v = 10
v <= 5 & v > 20

%
% Conditionals
%
% if-elseif-else
%
if v < 10
    %
elseif v < 20
    %
else
    %
end

%
% Iteration
%

% Compound interest
r = 0.04;
balances = zeros(1, 20)
balances(1) = 1700000
for i = 1:20
    balances(i + 1) = balances(i) * (1 + r)
end

r = 0.04;
bal = 100;
count = 0;
while bal < 200
    bal = (1 + r) * bal;
    count = count + 1;
end

%
% Functions
%
function out1 = copy(in1)
    % copy returns the input value
    out1 = in1
end

function [out1, out2] = copytwo(in1, in2)
    % copytwo returns the input values
    out1 = in1
    out2 = in2
end

function res = apply(f, arg)
    % apply applies f to arg
    %
    % Pass a function_handle to apply like this:
    % apply(@min, [10, 20])
    res = f(arg)
end
