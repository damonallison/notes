# Machine Learning

## Todo

* LR w/ a real data set
  * Feature selection
    * How to select features?
    * When to add new features?




## Questions

* How do we determine the optimal learning rate?
  * Idea: The smallest possible without becoming too slow?

---

## Week 1

ML: Getting computers to learn without being explictly programmed.

There are categories of problems that can't be directly programmed:

* Flying a a helicopter
* Handwriting recognition
* Image recognition

### Types of Machine Learning

* Supervised / Unsupervised Learning
* Reinforcment learning / recommender systems ()

Equally / more important as ML itself is determining how to apply ML in the real
world. How do you determine what types of models to use?

### Supervised Learning

Building a model with labeled (actual) data.

* Regression: Trying to predict a continuous valued output. (Price of a house, temperature)
* Classification: Trying to predict a discrete value output (rain, sun, snow)

* Support Vector Machines: Allow a computer to deal with an infinite number of features


### Unsupervised Learning

Building a model which learns the structure of data without labeled data.

Clustering is unsupervised. Clusters are learned from the data.

Examples (clustering):

* Google News: Clustering news stories together
* Facebook friends: who are related?
* Market segmentation: what groups of customers will buy a new product?
* Gene: group genes that are related by different variables: age, lifespan,
  location, roles, etc.

Examples (cocktail party):

* Separate out multiple audio sources (english vs. spanish, speech vs. music)

Octave (or matlab). High level environment used for prototyping. The right
environment makes implementing algorithms faster (higher level environment).

### Single Variable (Univariate) Linear Regression

The goal is to learn a function (h) which accurately predicts y for a given x.

Notation

* m = number of training examples
* x = input variable / feature
* y = output variable / feature
* (x, y) = specific training example
* (x (i), y (i)) = ith training example
* h = hypothesis - a function (model) which maps input -> output

The hypothesis function is the function which determines the linear line:

> `h(x) = Θ(0) + Θ(1)x`

* Θ(0) == theta zero (the first variable)
* Θ(1) == theta one (the second variable)

How do you select the model (hypothesis)?

### Cost (Loss) Function

The cost (or loss) function is the function used to determine the model's
success. The goal is to find the line which minimizes the output of the cost
function for all given inputs. In linear regression, the cost function is
typically the `squared error function`.

Ultimately, linear regression is a minimization problem. The goal is to minimize
a cost function.


### Gradient Descent

Gradient Descent is a process for minimizing a function. It's an iterative
algorithm which starts at one point and incrementally moves the point closer to
a minimum value.

Gradient descent converges on the minimum by taking the derivative of the cost
function (the slope) and move down.

At each iteration j, one should simultaneously update the parameters (O1, O2, O3).

The learning rate is the amount we move between different iterations of the
algorithm. If the learning rate is too small, it will take a lot of steps. If
too large, we may miss the minimum or start to diverge.

* Should we modify the training rate based on the derivative to speed up descent?
  * We don't need to.  As we approach a local mimimum, gradient descent will
    take smaller steps.

* How to find the global optimum if you are at a local optimum?


### Gradient Descent for Linear Regression

Goal: Use gradient descent to find the minimum error.

With linear regression, you'll only have one local optimum, the global optimum.

* "Batch" gradient descent. Batch means that at each step, we look at all training examples.
* Other approaches use a subset of all points at each step (Stocastic Gradient Descent?)

The normal equations method (from linear algebra) will find the global minimum without needing to use gradient descent. However, gradient descent will scale better than the normal equations method.

### Linear Algebra Review

* A matrix is a 2d array. Matrices are references row first, column second.
* Aij == ith row (down), jth column (1 based)
* Data scientists use 1-based indexing to reference elements in a vector.
* Matricies are refernced with capital letters (A, B, C), vectors lower (x, y, z).

```plain
[
  1 100 324
  1200 800 53
]

A(1, 1) == 1
A(2, 3) == 53
```

A vector is a single column. A vector has a "dimension" (number of rows). Here
is a "4 dimensional" vector. This is different terminology than an array.


y0 == 100
y1 == 120

```plain
[
  100
  120
  212
  321
]
```

### Matrix Addition, Subtraction, Multiplication

* + and - are applied to every element within each matrix.
* Each matrix must have identical dimensions for addition / subtraction.

* Multiplication of (i x n) * (n x j) matrices returns an (i x j) matrix, which
  each column of the second matrix multiplied by each row of the first. The
  result is an (i x j) matrix.

#### Matrix Multiplication

```plain

# Matrix x Vector
#
# Matrix multiplication (multiplying a 2x3 matrix with a 2x1 vector)
# For each row in the vector, multiply by each column in the matrix.
# The number of columns must match the number of rows in the vector.

[
  1, 3
  4, 0
  2, 1
]

*

[
  1
  5
]

[
  (1 * 1) + (3 * 5)
  (4 * 1) + (0 * 5)
  (2 * 1) + (1 * 5)
]

[
  16
  4
  7
]


# Matrix x Matrix Multiplication

# m

[
  1 3 2
  4 0 1
]

[
  1 3
  0 1
  5 2
]
```

#### Properties of matrix multiplication

* Matrix multiplication is *not* commutative.
  * A * B != B * A

* Matrix mutliplication is associative
  * A * B * C == (A * B) * C == A * (B * C)

* 1 is the identity operation
  * A * I = I * A = A
[
  1 0 0
  0 1 0
  0 0 1
]

#### Matrix Inverse / Matrix Transpose

* Inverse
  * 3 * inverse = 1
  * 3 * 3^-1 = 1
  * 3 * 1/3 = 1

* Only square (m x m) matricies *can* have an inverse.
* The 0 matrix does not have an inverse.
  * Any matrix that doesn't have an inverse is "singular" or "degenerate"


* Transpose

A = m x n
B = n x m

B(ij) = A(ji)

[
  1 2 0
  3 5 9
]

[
  1 3
  2 5
  0 9
]

---

## Week 2: Multivariate Linear Regression

### MATLAB / Octave

```matlab


v = [-2, -1, 0, 1, 2]

```

### Multivariate Linear Regression

* n == number of features
* x(n) == feature n (1 based)
* x(i) == ith training example
* xj(i) == jth feature within the ith training example

#### Feature Scaling

Feature scaling is a technique to get gradient descent to converge more quickly.
Rather than use the raw feature values in the gradient descent calculation,
faatures are scaled into a much smaller range of values.

Without feature scaling, if x1 takes values from 0-2000 and x2 takes values from
1-5, it will take a long time to converge. A very small change in x1 has much
less impact than a small change in x2.

Put every feature into a scale range. For example :

> -1 <= x(i) >= 1

or

> 0 <= x(i) >= 1

If a feature takes on values `-3 <= x >= 3`, scale the feature.

##### Mean normalization

Mean normalization involves subtracting the value of x from the mean of x,
dividing by the range (or standard deviation) of values.

`x = x - mean(x) / (max - min)`

##### Determining Learning Rate

How do you determining if gradient descent is working?

Plot the result of J(theta) for each iteration of gradient descent. It should be
approaching zero.

How do you know that gradient descent is working?

> If J(theta) isn't decreasing, it has converged.

Automatic convergence test: declare convergence if J(theta) decreases by less
than E in one iteration, where E is some small value (say 10^-3). In practice,
it's hard to choose E.

###### How to determine what learning rate should be used?

If theta isn't converging, use a smaller learning rate.

If J(theta) is small enough, J(theta) should decrease on every iteration.

* If learning rate is too small - slow convergence
* If learning rate is too large - may not decrease on each iteration, may not
  converge

* Try 0.0001, 0.0003, 0.01, 0.03, 0.1, 0.3, 1.
  * Choose the learning rate that is decreasing with every iteration.


### Features and Polynomial Regression

How do you choose the correct features to use?

You could create "synthetic" features based on data that you are given. For
example, if you are given frontage and depth of a house plot, you may use "area" - (frontage * depth).

Many times data is not linear, but rather quadratic or cubic. Polynomial
Regression fits a polynomial function to the data. We do this by creating
additional features which are powers of the original feature.

* x(1) = x
* x(2) = x^2
* x(3) = x^3

Note that when you create features which are powers of other features, feature
scaling becomes very important.


### Normal Equation

Rather than running linear regression, we just solve for J(theta) in a single step.

How does the Normal Equation work?  It finds the optimal values for all
coefficients without gradient descent. It does this by explicitly taking the
derivatives with respect to each theta and set them to `0`.

`theta = pinv((x' * x) * x' * j`

#### Gradient Descent vs. Normal Equation

When should we use the Normal Equation vs. Gradient Descent?

When the number of training examples is > 10,000, the normal equation will be
slow (Computing pinv(x' * x) is O^3).

Gradient Descent

* Need to choosing the learning rate.
* Needs many iterations
* Fast. Works well when n is large

Normal Equation

* No need to choosing the learning rate.
* No need to iterate.
* Slow when n is large (O^3)


##### Noninvertibility

What if (X^tX) is *not* invertible? Most matrices should be invertible

```
pinv: pseudo inverse - will work w/ non-invertible matrices (use this)
inv: inv
```

How do matrices become non-invertible?

* Redundant features (x1 = size in feet, x2 = size in meters)
* Too many features (10 training examples w/ 100 features)

### Octave / Tutorial

#### Vectorization

Think of iteration in terms of vectors.

```matlab

% An unvectorized prediction algorithm for j = 1->n

prediction = 0.0;
for j = 1:n+1
  prediction = prediction + theta(j) * x(j);
end;

% Vectorization

prediction = theta' * x


% Gradient Descent

```

for j = 1:3
  u(j) = 2 * v(j) + 5 * w(j);
end;

u = (2 * v) + (5 * w)



---

## Week 3 : Logistic Regression (Classification)

* Classification, the cost function to LR, multi-class classification.
* Regularization: helps prevent models from overfitting

### Classification

The output is a discrete class (0 or 1).

* 0 = "Negative Class" (i.e., not spam)
* 1 = "Positive Class" (i.e., spam)

* Email - spam / not spam
* Online Tx - fraud / not fraud
* Demographics - upper / middle / lower (multi-class classification problem)


Should we use LR for classification?

* Adding outliers throws off LR.
* LR is *not* a good algorithm for classification.
* LR can return values < 0 and > 1.

The predictions of logistic regression (classification) are always between 0 and 1.

`0 <= hΘ(x) <= 1`

### Hypotheses Representation

Logistic Regression uses the "Sigmoid Function", also called the "Logistic
Function" (a sinusoid). It maps any real number to the (0, 1) interval, making
it better for classification.

```plain

hΘ(x) = g(Θ^tx)

z = Θ^tx

g(z) = 1 / (1 + e^-z)

```

The Logistic Function gives us the probability our output is 1.

### Decision Boundary

The decision boundary is the line that separates the area where `y == 0` and `y == 1`.
It is created by our hypothesis function.

**IMPORTANT**

The training set does *not* define the decision boundary. The training set helps
define Θ, but the decision boundary is a property of the hypothesis function.
Once Θ has been defined, the training data *cannot* influence the decision
boundary.

When will the Logistic Regression function return 1?

* Predict 1 when `hΘ(x) >= 0.5`, thus when `z >= 0`, thus when `Θ^Tx >= 0`
* Predict 0 when `Θ^Tx < 0`

The decision boundary is the line which separates the hypothesis returning 0 vs. 1.

5 - x1 >= 0.5
4.5 < x1


Non-linear Decision Boundaries. When higher order polynominals are used, the
decision boundaries will become more complex shapes.

### Cost Function

* How do you choose a hypothesis function?
* How to choose parameters for Θ?

### Regularization / Overfitting

#### Underfitting

Underfitting occurs when the algorithm doesn’t fit the training data well (high
bias). It is usually caused by a function that is too simple or uses too few
features.

“High bias” is the term used to describe a function that doesn’t fit the data
well. For example, a linear function is “biased” towards the data fitting a
linear model. When the data doesn’t fit the linear model, the function is said
to have “high bias”.

#### Overfitting

Overfitting occurs when the function matches training data well but doesn’t
generalize well to non-training data. Also called “high variance”. It is usually
caused be a function that is too complex or uses to many features

If we have too many features, the learned hypotheses fits the training data too
well, but fails to generalize to non-training data.

#### Addressing Overfitting

How can we address overfitting?

* Reduce the number of features
    * Manually select / combine features
    * Model selection algorithm (described later in course)

* Regularization
    * Keep the features, but reduce magnitude of the parameters (theta)
    * Works when we want to have a lot of slightly useful features that we don’t want to throw away.


### Regularization: Cost Function

Rgularization "regularizes" or penalizes the features you want to limit by
increasing their cost. When you increase their cost, the coefficient must be
smaller for the overall cost to be lower. Thus, the feature becomes less and
less influential.

How do you pick which parameters are relevant? You can shrink them all by the
same amount (lambda == ƛ). How do choose the right lambda value? Mulit-selection can
help us choose a lambda (later in course).

If ƛ is too large:

* Algorithm works fine; setting ƛ very large can't hurt it.
* Results in underfitting.
* Gradient descent will fail to converge.


#### Quiz Notes

* Adding additional features does *not* always improve model performance.
  Additional parameters exposes you to overfitting.

* Regularization does *not* improve performance on the training set.


---

## Week 4: Neural Networks: Representation

Neural networks are inspired by how the brain works. NNs help solve problems
like speech or image recognition.

Why NN? For non-linear hypothesis. Linear works for simple problems with a small
set of features. If you include just second order terms in a 100 feature
problem, you end up with 5000 features. Grows O(n^2) == n^2 / 2. That's a lot of
features. You'll end up overfitting. If you only include the quadratic features,
it won't fit the data set. You can't fit a more complex data set.

If you include the third order polynominal features, you'd have O(n^3) features
(170k).

For many problems, the number of features will be large. Image recognition. What
is the dimension of the feature space? If we use individual pixels, even on a
50x50 image, you have n = 2500. If you are using RGB, you'd have n = 7500.
Quadratic features you'd have 3m features.

Linear classifiers won't work when the feature set is large. We need a different
type of learning algorithm, one that can deal with a large number of features.

### Neurons and the brain

The goal of traditional ML algorithm (80s / 90s) was to mimic the brain. NNs
have had a resurgence. They require computers fast enough to run large scale
NNs. Today, NNs are "state of the art".

How does the brain work? If you wire up vision to the brain's auditory cortex
(neuro-rewiring), the auditory cortex will learn to see.

The brain is adaptable. If you plug in a new sensor into the brain, it will use
it (3rd eye). The goal of NNs is to mimic the underlying pattern the brain uses
to learn.


### Model Representation

NNs are simulating network of neurons (cells).

`Dendrites (inputs) -> neuron -> Axon (output wire)`

A neuron receives inputs, does it's computation, and sends it result to other
neurons. Stacking neurons is how the brain work (senses / muscles). Small pulses
of electricity (messages) thru neurons.

Neuron model: Logisitc unit ("bias unit") - uses logistic regression. Sigmoid
(logistic) is called an "activation function" in NN terms. NNs call theta
parameters "weights".

An NN is a set of layers with different neurons strung together.

## Week 5: Neural Networks: Learning

* What is the cost function for a NN?
* How do we determine theta (weights) for each node of an NN?

### Cost Function

#### Unrolling Parameters

* `fminunc` expects theta as a vector. Thus, theta needs to be "unrolled" into a vector
  * `Theta = [Theta1(:); Theta2(:)]`

* With NN, theta is a matrix.

Assuming a 10x10x1 NN:

* Theta1 == 10x11
* Theta2 == 10x11
* Theta3 == 1x11

* D1 = 10x11
* D2 = 10x11
* D3 = 1x11

```matlab
%
% "Unrolling turns theta into a large vector.
%
% Why do you want to do this? The optimization functions
% expect your parameters to be unrolled into a large vector.
%
thetaVec = [Theta1(:); Theta2(:); Theta3(:)]
deltaVec = [D1(:); D2(:); D3(:)]

Theta1 = reshape(thetaVec(1:110), 10, 11);
Theta2 = reshape(thetaVec(111:220), 10, 11);
Theta3 = reshape(thetaVec(221:231), 1, 11);

% Invoking a learning algorithm (i.e., fminunc)
%
% * Assume you have initial pameters theta1, theta2, theta3
%
% * Unroll to get `initialTheta` to pass to fminunc
% * fminunc(@costFunction, initialTheta, options)
%
% Implement costFunction
%
% function [jVal, graidentVec] = costFunction(thetaVec)
%
%   from thetaVec, reshape to get back theta1, theta2, theta3
%   use forward / back prop to compute D1, D2, D3 and jVal
```

#### Numerical Gradient Checking

* How do you know your cost function is working correctly? Even if J is
  decreasing, you could still have a bug.

* Gradient checking ensures forward / back propogation is correct.

* Compute `theta + epsilon` and `theta - epsilon`. Connect by a straight line.
  Compare that slope to the derivative at `J(theta)`. They should be almost
  identical.

* Use a small epsilon, but not too small
  * `e == 10^-4`

```mat

gradApprox = J(theta + epsilon) - J(theta - epsilon) / 2 * epsilon

```

To check a derivative of a vector.

* Approximate all derivatives for all theta parameters (1->n).

```mat
for i = 1:n
  thetaPlus = theta;
  thetaPlus(i) = thetaPlus(i) + ESPILON;
  thetaMinus = theta
  thetaMinus(i) = thetaMinus(i) - ESPILON
  gradApprox(i) = (J(thetaPlus) - J(thetaMinus)) / (2 * ESPILON)

  % Verify that gradApprox ~~ DVec (the graident you got from back prop)
```

How to implement gradient checking:

* Implement backprop to compute DVec (unrolled D(1), D(2), D(3))
* Implement numerical gradient check to compute `gradApprox`
* Make sure they give similar values (within .01 or so)
* Turn off gradient checking. Use backprop for learning

Important:

* Be sure to disable gradient checking before training your classifier. If you
  run numerical gradient computation on every iteration of gradient descent (or
  in the inner loop of `costFunction`), your code will be very slow. Back prop
  (delta vector creation using back prop) is much faster.

#### Random Initialization

What should our initial value of theta? Always 0s?

All zeros do *not* work for training a NN. If you do that, all nodes and their
derivatives will have the same values. The hidden units compute the same values.
All weights always stay the same. (Symmetric weights)

We use random initialization to set initial weights (symmetry breaking).

```mat
theta1 = rand(10, 11) * *(2 * INIT_EPSILON) - INIT_EPSILON
theta1 = rand(1, 11) * *(2 * INIT_EPSILON) - INIT_EPSILON
```

#### Putting it Together

##### Pick a network architecture.

Pick a network architecture. While the number of input (features) and output
(classes) are fixed, we must decide how many hidden layers and neurons per layer
to use.

  * How to decide how many hidden units / how many layers?
    * By default, use single hidden layer.
    * If you use > 1 hidden layer, use same number of neurons in each hidden
      layer.
  * How many neurons in each layer?
    * The more nerorns the better. More neurons will be more expensive to
      compute, but usually better.
    * While not required, the number of neurons per layer should generally
      relate to the number of features. For example, the number of neurons can
      be 2 or 3 times the number of input features.

##### Training a neural network

* Randomly initialize weights.
* Implement forward prop to get the value of h(x) for any x.
* Implment cost function.
* Implement back prop to compute partial derivatives.
  * Use `for 1 = 1:m` to implement forward / back prop for each training
    example.
    * Find activations (forward prop).
    * Find delta terms (back prop) for each node and overall DELTA.
  * Compute partial derivative terms (with regularization).
* Use gradient checking to compare partial derivatives found using back prop.
* Disable gradient checking.
* Use gradient descent or `fminunc` with backprop to try and minimize the cost
  function.

**Note that the cost function is *NOT* convex. It is succeptible to local minimums**

### Week 5: Review

* We use the same cost function as in logistic regression, however we sum the
  cost for each `k` output.

* Regularization regularizes the theta value for *each* node in the network.

* Backpropogation determines the error (gradients) for eacn node of the
  network, starting with the output layers, working back thru layer 2, assign