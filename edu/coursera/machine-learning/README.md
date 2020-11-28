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

---
---

### Week 5

Training neural networks.

* Feed forward, backpropogation, gradient checking, random initialization.

### Review

* We use the same cost function as in logistic regression, however we sum the
  cost for each `k` output.

* Regularization regularizes the theta value for *each* node in the network.

* Backpropogation determines the error (gradients) for eacn node of the
  network, starting with the output layers, working back thru layer 2, assign

---
---

### Week 6

* How do you know your model is working? What should you do if your model
  doesn't generalize well?

* What do you do when the model isn't working? What should you do next?
  * Get more data / more training examples. (Could be really expensive)
  * Smaller set of features (you are overfitting)
  * More features (polynominal features)
  * Increasing / decreasing lambda

* People typically go with gut feel on what to do next. It's random.

* How to evaluate learning algorithms

* Machine learning diagnostics. A test to understand what's working and what's
  not, and get guidance on how to best improve performance.

#### Evaluating a Hypothesis

* Less error != a good hypothesis (overfitting)

* How to determine if a model is overfitting?
  * Split test data into training / test sets. Typically a **70/30%** random split.

##### Training / testing process

* Train your model (i.e., find theta to minimize cost over a training set).
* Compute error on `test` set. i.e., Average square error over the test set (for
  linear regression, logistic regression cost function).
  * You could also use `misclassification error`. A boolean (1 or 0) for each
    example - 0 if correct, 1 if correct.



#### Machine Learning System Design

The real world process / work tasks for putting together an ML system.

Example: Building a spam classifier.

1. Determine features. What data elements are most likely to predict future data?
   * Features may be a list of the most freqently occurring words found in emails.

Where do you spend your time to make it have low error?

* Collect lots of data. May be expensive
* Develop sophisticated features based on email routing headers / routing information.
* Develop sophisticated features based on message body (use root words
  (stemming), misspellings (w4tches)).

It's hard to predict which features will be the best. Don't fixate on one or two
options. Don't base your research on gut feel, have data to back up your
hypothesis.

#### Error Analysis

How do you systematically make decisions on what to work on?

* Prototype! Start with a simple algorithm. Implement and test on cross-validation data.
* Plot learning curves to decide if more data, more features are likely to help.
* Error analysis: manually examine the example (in CV set) that your algorithm
  made errors on. See if you can spot any trend in what type of examples it's
  making errors on.

Example: email classification.

* If your algorithm classifies 100 emails incorrectly, what is common among
  those 100 emails?
* Can you come up w/ better features to classify them correctly? (i.e.,
  Examining SMTP headers / routing information / bad domains?)

**Focus on the most difficult examples to classify.**

##### The Importance of Numerical Evaluation

Use a single real number (i.e., cross validation error) to determine how your
algorithm is doing. You need a concrete baseline to determine how much the model
is improving or regressing when you update / change features.

Use the cross validation set to determine error. Otherwise, you'll be
implementing something that fits the test set and not generalize well.

##### Handling Skewed Data

Skewed classes occur when one actual result is so predominant it makes
classification accuracy irrelevant. For example, if 99.5% of the actual results
are `0`, a model that has 99% accuracy is *worse* than simply predicting `0` all
the time.

###### Precision / Recall

Helps us determine if the classifier is performing well with skewed data. It is
a better metric than looking at classification error when you have skewed data.

* Precision: `(true positives) / (true pos + false pos)`
* Recall: `(true positives) / (true pos + false neg)`

High precision / high recall is a good classifier. A low precision and low
recall is not a good classifier.

##### Trading Off Precision and Recall

In typical logistic regression, we predict 1 if h(x) >= 0.5.

What if we want to be *really* confident in the results (i.e., 0.9) - (higher
precision, lower recall).

What if we want to avoid false negatives? (i.e., 0.2) - (higher recall, lower
precision).

For example, assume we are predicting if a patient has cancer.

* Higher precision: we want to be really confident when we tell someone they have cancer.
* Higher recall: we want to ensure that if there is even a *small* chance the
  patient has cancer, we tell them.

Which is better? That depends on what you want. Both cases have value.


###### F Score

How do we compare different precision / recall numbers?

| Algorithm | Precision (P) | Recall (R) |
| --------- | ------------- | ---------- |
| 1         | 0.5           | 0.4        |
| 2         | 0.7           | 0.1        |
| 3         | 0.1           | 1.0        |


How do you determine which algorithm is the "best"? The higher `F Score` the
better. If Precision or Recall == 0, you'll get a really low score.

`F Score = 2 (PR / (P + R))`

If you want to automatically find the "best" threshold value to use, try
multiple threshold values and choose the one with the highest `F Score`.


##### Large Data For Machine Learning

How much data to train on? Is more data always better? (Banko and Brill, 2001)

> "It's not who has the best algorithm that wins, it's who has the most data"

When does a massive data set help?

* Assume we have sufficient features to predict `y` accurately.

How do you know you have sufficient features? Ask yourself:

> Given the input x, can a human expert confidently predict `y`?

When you have an algorithm with many features / NN with many features (low
bias), use a large training set (unlikely to overfit). Bias is addressed by
adding a lot of features. The large training set is addressed by having a lot of
data.

---
---

## Week 7

### Support Vector Machines: Optimization objective

SVM can give a cleaner, more powerful way to learn complex, non-linear
functions. This is the last supervised learning algorithm taught in the class.

SVM's determine decision boundaries by maximizing margin between training
examples. The cost function is penalized when the distance between the decision
boundary and the training examples is low (based on vector distance between
theta and the training example). Because SVMs are finding the decision boundary
by maximing margin between examples, it's called a "large margin classifier".

Kernels are functions which apply cost to theta's proximity to landmarks. The
closer theta is to landmarks, the more likely we'll predict positive. Different
kernels can be used. The Gaussian kernel is used in the class.

SVM is a bit more strict than linear regression. In linear regression, we
predict `1` when `theta(T) * X >= 0`. With SVM, we predict `1` when `theta(T) *
X >= 1`. The same applies for `0`. This means we have to be more sure of
ourselves when predicting.

* if y == 1, predict 1 when theta(T) * X >= 1
* if y == 0, predict 0 when theta(T) * X <>= -1

#### Choosing landmarks

How do we choose landmarks? Make each example is a landmark.

f(0) = 1
f(1) = similarity(x, l(1))
f(2) = similarity(x, l(2))
...
f(m) = similarity(x, l(m))

The features are used as the feature vector in the SVM calculation.

### SVM With Kernels

* Given x, compute features (similarity using kernel).
* Predict y =1 if theta(T)*f >= 0

How do you get theta?

Use the SVM function to obtain theta.

```plain

J = C * (sum(y(i) * cost(theta(T) * f)) + ((1 - y(i)) * cost(theta(T) * f))) + (1/2 * theta(T) * theta)

```

In the regularization term, ignore theta(0)

Why don't we apply kernels to linear regression (landmarks)? The computational
tricks done with SVM do not generalize well to linear regression. It's slow.

### How do you choose C?

C = 1 / lambda

Large C: Lower bias, high variance. Overfitting. Not using much regularization.
Smaller C: Higher bias, low variance. Underfitting. Uses high regularization.

Sigma (used in kernel)

Large sigma: Features vary more smoothly. Higher bias, lower variance.
Small sigma: Features vary more abruptly. Lower bias, higher variance.


### Using an SVM

SVM software packages: `liblinear`, `livsvm`.

* Choose parameter C
* Choose kernel (similarity function)
  * No kernel == "linear kernel" (theta(T) * X) >= 0
    * Use a linear kernel when n is large, m is small.
    * You just want a linear decision boundary.
  * Gaussian kernel. Choose sigma.
    * When to choose Gaussian? n is small and/or m is large.

* You may need to implement a kernel. (similarity function)

NOTE: Perform feature scaling before using the Guassian kernel. Otherwise,
features with larger values (housing cost) will dominate smaller features
(number of bedrooms).

###  Multi-class Classification

Many SVM packages include multi-class classifiers.

Use the one-vs-all method. Train K SVMs, one for each class (k). Pick class with
largest (theta(T) * x).

#### Logistic Regression vs. SVM

* n = number of features
* m = number of training examples

* If n is large (relative to m)
  * Example: n is 10,000. m is 1000
  * Use logistic regression or SVM without a kernel (linear kernel)

* If n is small (1-10000) m is intermediate 10-10000
  * SVM with a Gaussian kernel

* If n is small (1-1000), m is large(50,000+)
  * Create / add more features
  * Use logistic regression or SVM without a kernel

Linear regression and SVM wtihout a kernel are very similar implementations.

The power of SVM is with finding non-linear boundaries.

A NN likely to work, but be slower to train.

The learning algorithm you choose (linear regression, support vector machines)
sometimes isn't as important as how much data you have, feature selection, or
how good you are at debugging / analysis.

---
---
## Week 8:  Unsupervised Learning

Unsupervised learning does *not* have labeled training examples. Clustering is
an unsupervised learning algorithm which groups inputs into like clusters.

We ask the algorithm to find the structure in data.

Why clustering?

* Market segmentation: which customers are alike?
* Social network analysis: who are related?

### k-Means Clustering

* Group data into k clusters.
* Repeat until a determined convergence (a metric you can determine. perhaps the
  total delta of cluster movement < a threshold)
  * Cluster assignment step. Assign each point to a centriod.
  * Move centroid step. For each cluster, finid the mean and move to the new
    center.
* When centroids do not change, you are done.

#### Algorithm

* k = number of clusters
* Training set (x)

* Randomly initializes k centroids
* Repeat
  * for i = 1:m
    * find cluster centroid closest to x(i)
  * For k = 1:K
    * Average (mean) of points assigned to k. Move to mean.
  * Remove any centriods without any points assigned to it (very rare).

What if the data set is not separated? (Linear)? K-means will still work.

#### Optimization Objective

k-Means
* c(i) = the centroid to which x(i) is assigned.

J(c(1), ... c(m)) = (1/m) * sum((x(i) - mu(i)) ^ 2)

#### Random Initialization

How to initialize cluster centroids?

* Randomly pick `K` training examples, set mu(1-k) equal to these examples.

* k-Means can end up at a local optima.
* Try multiple random initializations / run k-means multiple times. Pick lowest
  cost. The higher `k`, the less likely multiiple iterations will help much.

#### Choosing K

* Most common: choose manually. You typically know how many clusters you want.

* Elbow method
  * Determine where `J` "elbows" for each `k`. Where it elbows is the optimal `k`.
  * The elbow method doesn't really work like that. There is no "elbow".


Homework

How good do you want the image to look vs. how much do you want the image
compressed?

### Dimensionality Reduction (Data Compression)

* Uses less data, speeds up learning algorithms.
* Remove redundant features (i.e., size in cm. and in. are redundant)
  * Highly correlated features can be reduced into one.
  * Come up with a new features which are a consolidation of multiple features.
  * 2D (x1, x2) can be projected into an z1 line.
  * 3D (x1, x2, x2) can be projected into a (z1, z2) plane.

### Dimensionality Reduction (Visualization)

* Reducing 50 dimensions into 2 (summarizes 50 dimensions) we can visualize the
  data better.
* It is up to us to determine how to reduce the dimensions. Basically by
  grouping.

### Principal Component Analysis (Dimensionality Reduction)

PCA tries to find a lower dimensional surface which minimizes the sum of square
error (projection error).

* 2D -> 1D projections find the line of best fit.
  * Reducing two dimensions into one.
      * Find a vector which minimizes the projection error.
* 3D -> 2D projections find the plane of best fit.

* For n dimensions -> k dimensions
  * Find k vectors onto which to project the data to minimize the projection
    error.

### PCA Algorithm

How do you find the surface onto which to project the data?

Data Preprocessing (before performing PCA):

* Mean normalization
  * mu(j) = sum(x(j)i) / m
  * Replace x(j)i with x(j)i - mu(j)

* Feature scaling
  * Scale features to have a comparable range of values.

* How to find the vectors?
* How do we replace the x values with the new z values.

* Compute the covariance matrix
* Eigenvectors

#### Summary

* Mean normalize
* Feature scaling
* Find sigma
  * `sigma = (1/m) * X' * X(j)`
    * sigma == n x n matrix
* Find `U` vectors (the reduced dimensions)
  * `[U, S, V] = svd(sigma) % singluar value decomposition`

* Take the number of `k` vectors you want to reduce your data to
  * `ureduce = U(:, 1:k)`

* Compute the new features (`z`)
  * `z = ureduce' * x`

### Reconstruction from compressed representation.

* `x(approx) = ureduce * z`
  * An approximate of the original representation.

### How to choose k (the number of principal components)

1/m * sum((x(i) - xapprox(i)) ^ 2)
Average square projection error
      --- divided by ---
Total variation in the data.
1/m * sum(x(i) ^ 2)

Choose k to be the smallest value so that:

* "99% of the variance is retained"

Many features are highly correlated, so you can frequently reduce dimensions
without losing variance. You can typically reduce a 10,000 feature set into
1,000.

Proposed algorithm:

* Try k = 1
* Compute U(reduce)
* Check variance
* Keep trying until you find `k` with 99% variance retention

^^ This algorithm is slow. You don't need to do it. `svd` will return the
  variance retained for each value of `k`.

`[U, S, V] = svd(sigma)`

* S == everying on the diagonal is non-zero.
* Traverse the `S` diagonal, stopping when you find a `k` which retains 99% of
  the variance:

```
1 - (sum(1 -> k)(s(ii)) / sum((i -> n)s(ii))) <= 0.01

or

(sum(1 -> k)(s(ii)) / sum((i -> n)s(ii))) > 0.99
```

### Advice for Applying PCA

WHy PCA:

* Compression
  * Reduce memory / disk
  * Speed up learning algorithm

* Visualization
  * Typically choose k == 2 or k == 3 in order to visualize it


#### Supervised Learning Algorithm

Reduce features before you train the learning algorithm.

* When `x` is high (100 x 100 pixels == 10,000 features)
* Extract inputs
* Reduce input w/ PCA (map x -> z (reduced))
* Use the new training set `(z1, y1), (z2, y2), ...`

* PCA defines a mapping between x -> z.
* Run PCA *only* on the training set to get the mapping. The mapping can be used
  on the CV and test sets.

* Do *not* use PCA to prevent overfitting. Use regularization instead.
* PCA does *not* use the labels (y). PCA throws away some information (variance)
  without knowing what the values of (y).

* Do *not* use PCA unless you absolutely need it. Do you *need* PCA? Can you run
  your algorithm just fine without PCA, with the raw data?

PCA is an incredibly useful step. It speeds up the running time, reduces memory
uses, and makes your data visualizable.

### Quiz

1. PCA should return a +-u vector that corresponds to the data pattern.
2. You want the sum of the adjusted distance to be *small* when divided by the
   actual distance.
3. Smallesk `k` which retains 99% of the variance.
4. Which are true
  * Use feature scaling before PCA if the features are on different scales.
  * PCA compresses x(n) to a lower dimensional vector z(k) where `k < n`
5. Recommended applications of PCA:
  * Reduced dimensions = reduced memory = faster performance
  * Data visualization

---
---
## Week 9 - Anomaly Detection / Recommender Systems

Abnomaly dectection: Model a dataset using a Gaussian distribution and look for
outliers. Useful for finding abnormal elements (credit card fraud, manufacturing
defects).

Recommender systems (Amazon, Netflix) use collaborative filtering algorithm and
low-rank matrix factorization.

### Anomaly Detection: Problem Motivation

Mostly like unsupervised learning, but has properties of supervised learning.

How to determine if an example is anomalous?

Build a model for P(x). If P(xtest) <= epsilon - it is an anomaly. That means,
if the cumulative product of the probability of each feature occuring is less
than a known threshold (say 0.03, it is considered an outlier).

#### Example: Fraud detection

* Features (detecting fraudlegent website behavior):
  * Number of webopages viewed
  * Typing speed
  * Number of transactions
  * Time of day
  * Number of attempts

#### Example: Monitoring computers in a data center

* Features
  * Memory / CPU / I/O / ...

#### Example: Manufacturing

* Features
  * Propoerties of the product (weight, height, heat, speed, etc..)


### Gaussian (Normal) Distribution

A normal distribution is a bell shaped curve with the peak at mu, and the width
as sigma (standard deviation). When sigma is small, the width becomes tighter
(smaller variance). It's half as wide, but twice as tall. The area is *always* 1
since it's a probability distribution.

* Mean (mu)
* Variance (sigma^2)

`x ~ N(mu, sigma^2)`  % ~ == "distributed as"

### Parameter Estimation

Given a data set, what are the values of mu and sigma^2?

```matlab
mu = 1/m * sum(x)
sigma^2 = 1/m * sum(x - mu)^2
```

### Anomaly Detection Algorithm (Density Estimation)

Given we have a set of m training examples. Assume each feature (x1, x2, etc...)
in the training examples follow the Gaussian distribution.

* Find mu and sigma for each feature
* Multiply the probability of each feature according to it's mu and sigma^2.

```matlab
p(x1; mu(1), sigma(1)^2) * p(x2; mu(2), sigma(2)^2) * p(x3; mu(3), sigma(3)^2) * p(xn; mu(n), sigma(n)^2)
```

1. Choose features (x(i)) that you might think will be indicative of anomalous example (i.e., what features would describe fraud)
1. Find mu and sigmal for each feature.
1. Compute probability for a training example by taking the product of all
   feature probabilities.
1. If the probability is < epsilon, you have an anomaly.

Think of mu as a vector. You can vectorize mu and sigma. (How?)

### Developing and Evaluating an Anomaly Detection Sytem

How do you evaluate an anomaly detection algorithm? Will adding another feature
make my anomaly detection algorithm better?

In order to determine the quality of the model detecting anomalies, we use a
similar approach to that used in supervised learning. Namely, we train a model
using a training set, optimize it on a cross validation set, and verify it using
a test set.

* Assume we have some labeled data (known alomalies). (y = 0 (normal), y = 1 (anomaly))

* Build training / CV / test sets
  * Training (60%): assume it has no anomalies
  * Cross validation (20%) / test set (20%) should have a few known anomalies.

* Fit model (p(x)) on the training set
* On the CV, predict anomalies (y = 0 if p(x) >= e, y = 1 if p(x) < e)
* Because the data is skewed, evaluation accuracy is *not* a good evaluation metric.
* Compute the precision / recall and F1 score. The higher the F1 score the better.

* We can use the CV set to choose the parameter `e`.
* Pick the epsilon which gives us the highest f1 score.

### Anomaly Detection vs. Supervised Learning

When should we use anomaly detection and when should we use supervised learning?

Anomaly detection

* Small number of positive examples (anomalies)
* Large number of negative examples
* Many "types" of anomalies. Hard to learn what an anomaly is from positive examples.


Supervised Learning

* Large number of both positive / negative examples.
* Enough positive examples for an algorithm to understand what an anomaly is.
  Future examples likely to be similar to the ones in the training set.

Key difference: in anomaly detection, we don't have a lot of positive examples.
We don't have enough data for a learning algorithm to understand what an anomaly
is.

### Choosing What Features to Use

Post a histogram of the data. The data should look somewhat Gaussian. It's not a
hard requirement that it's Gaussian, but it's better if it does.

If the data doesn't look Gaussian, transform the data to try and make it more
Gaussian. (log(x), sqrt(x))

```matlab
hist(x, 50) % 50 bins
hist(x.^0.5, 50)
hist(log(x), 50)
```

How to select the features?

Make sure the anomalies are really anomalies. Create features so that anomalies
are truly anomalies. Look at the anomalies that the algorithm is failing to
flag.

Want p(x) large for normal examples. p(x) small for anomalies.

Most common problem: p(x) is comparable for both normal and anomalous examples.
(Anomalies aren't really anomalies, they are mixed into normal examples)

Choose features that might take on unusually large or small values in the event
of anomalies. Example: a computer stuck in an infinite loop (CPU high, but low
network traffic). Create a new feature (x5 = (cpu load)^2 / network traffic).
When x5 is high, you'll detect the anomaly.

### Multivariate Gaussian Distribution

What if examples aren't very anomalous?

Rather than modeling all features separately, we model them all together.

Setting sigma

mu = [0; 0]
sigma = [1 0; 0 1]

When you vary sigma non-linearily, you'll vary the distribution of what is considered an "anomaly".

```matlab
%
% Here, we are saying that x1 has a smaller distribution of values
% and x2 has a wider distribution of values.
%
sigma = [0.6, 0; 0 2]
```

You can also use multi-variate Gaussian to get different versions of distributions.

sigma = [1 0.8; 0.8 1] % x1 and x2 are closely related.

### Anomaly Detection using Multivariate Gaussian Distribution

1. Fit model p(x) by finding mu and sigma
1. Given a new example `x`, compute `p(x)`
1. If `p(x)` is small (`< e`), flag the example as an anomaly.

What is the relationship between normal gaussian anomaly detection and multivariate gaussian detection?

The original model is the same as the multivariate case, except it doesn't
account for correlations between features.

When would you use the original vs. multivariate Gaussian models?

Original model:

* The original model is used more often.
* Manually create features to capture unusual combinations (correlations) of
  features.
* Computationally cheaper, scales better.

Multivariate Gaussian:

* Automatically captures correlations between features.
* Computationally more expensive.
* Must have m > n (examples > featuers). Use multivariate only when m
  substantially (10x) larger than n.

**Eliminate redundant features before doing anomaly detection (causes sigma to be non-invertible)**

* Redundant = features that are linearily dependent.


### Quiz (Anomaly Detection)

1. Anomaly detection is suited for data sets with a really small set of outliers.

* Fraud
* Unusually unhealthy patients

2. The cross-validation set is missing many fradulent transactions when p(x) < e.

You need to increase epsilon to count more examples as anomalies.

3. You are detecting anomalies in engine manufacturing. You expect `x1 ≅ x2`.
   One of the suspected anomalies is that a flawed engine may vibrate very
   intensely even without generating much heat (large x1, small x2), even tho
   they don't individually fall outside their typical range of values.

x(1) = vibration intensity
x(2) = heat generated

You want to create a feature which exposes the relationship between x1 and x2.

`x3 = x1 / x2`

4. Which of the following are true?

* Classification accuracy is *not* a good metric to use when doing anomaly
  detection (skewed data).

* We *do* want to select an appropriate numerical performance metric to evaluate
  the model's effectiveness.

* We *do* want to fit a model to all negative training examples.

* In a typical anomaly detection setting, we have a *small* set of anomalous examples.


### Predicting Movie Ratings

Recommender systems. A very important topic. People want to recommend things to
you based on your history, what similar people have liked.

Features are important to ML. Some algorithms can "learn" which features you
want to use.

Example: Predict movie ratings

* Users rate movies 1-5 stars

* n(u) = number of users
* n(m) = number of movies
* r(i, j) = 1 if user j has rated movie i
* y(i, j) = rating given by user j to movie i (defined only if r(i, j) = 1)

Given the data set, we want to predict the values of missing ratings. High
predictions are candidates to recommend.

### Content Based Recommendations

How would users rate movies they have not yet rated?

* Give each movie a set of features
  * x1 = degree to which a movie is a romance movie
  * x2 = degree to which a movie is an action movie
  * x3 = ...

* For each user `j`, learn theta using linear regression.
* Predict user `j` as rating movie `i` with `theta(j)' * x(i)`

### Content Based Recommendations: Optimization Objective (Learning theta)

You want to minimize the error for all of a user's ratings.

```
min(theta(j)) : 1/2 sum((all ratings)((theta(j))' * x(i) - y(i, j)) ^ 2 + ((lambda / 2) * sum(theta(k)(j)) ^ 2)
```

We want to learn theta for *all* users. Each user has their own learned theta.

### Collaborative Filtering

It learns data set features by itself. (i.e., We don't have labels for each
movie. Can we learn them?)

Assume we ask users if they like romantic movies or action movies (the
features). We use the combination of user preferences (as theta), and their
reviews, we infer the features of a movie.

For example, if Alice really likes action movies and rates a movie high, it's
probably an action movie. That movie has a high "action" feature value.

It's called "collaborative learning" because all users are collaborating to help
the algorithm to learn better features.

Given we have theta (user preference), we want to find `x`.

* If we are given user preferences and ratings, we can determine features.
* If we are given features and preferences, we can predict if a user will like
  it (theta).

### Collaborative Filtering Algorithm

* If you are given `theta` (user gives us preferences), you can solve for `x`.
* If you are given `x`, you can solve for `theta`.

You could go back and forth to continually improve `x` and `theta` by finding
`x`, using that to find `theta`, using that to improve `x` and so on.

You can combine both objectives (finding `x` and `theta`) into a single linear
regression problem by regularizing both `x` and `theta`.

What is the derivative of multiple parameter sets?

We do *not* add `x0` or `theta(0)` because we are learning the features. If the
algorithm wants an `x0` feature, it will learn it.

Algorithm:

1. Initialize `x(1) -> x(n)` and `theta(1) -> theta(n)` to small random values.
1. Minimize `J(x(1) -> x(n), theta(1) -> theta(n))` using gradient descent for
   every `i` and `j`.
1. For a user with parameters `theta` and a movie with (learned) features `x`,
   predict a star rating of `theta' * x`.

```
%
% Partial derivatives of x and theta
%
x(k)(i) = x(k)(i) - ((learning rate) * sum(r(i, j)(theta(j)' * x(i) - y(i, j)) * theta(k)(j) + lamnda*x(k)(i)
theta(k)(j) = theta(k)(j) - ((learning rate) * sum(r(i, j)(theta(j)' * x(i) - y(i, j)) * z(k)(i) + lamnda*theta(k)(j)
```


### Vectorization: Low Rank Matrix Factorization

To create a ratings matrix `Y`, where `Y(i,j)` is the rating for the `i`th movie
by the `j`th user, we multiply `theta(j)' x(i)`.

[
  theta(1)' * x(1) theta(2)' * x(1) ... theta(num users)' * x(1)
  theta(1)' * x(2) theta(2)' * x(2) ... theta(num users)' * x(2)
  ...
  theta(1)' * x(num movies) theta(2)' * x(num movies) ... theta(num users)' * x(num movies)
]

The vectorized way to create this matrix: `X * THETA'`, where `X` and `THETA` are:

X =
[
  --- x(1)' ---
  --- x(2)' ---
  --- x(3)' ---
  ...
  --- x(num movies)' ---
]

THETA =
[
  --- theta(1)' ---
  --- theta(2)' ---
  --- theta(3)' ---
  --- theta(4)' ---
  ...
  --- theta(num users)' ---
]


### Finding related movies

If feature vectors are similar, they are similar. Find the movies with the smallest feature delta.

`|| x(i) - x(j) ||`

### Implementation Detail: Mean Normalization

Mean normalization makes the algorithm perform better.

Mean normalization: calculate the mean for each movie. Subtract the mean from
the actuals. Which normalizes each movie to have an average rating of zero.

Use the normalized Y matrix to learn `x` and `theta`. Add the mean back after when making the final prediction

`theta(j)' * x(i) + mu(i)`

If a user hasn't rated any movies, we'll predict the user will have rated each movie the mean. We an use this to recommend a new user movies.

### Quiz

Given a set of theta for each user and x for each book, what is the "training
error". What are the correct ways of doing this?

