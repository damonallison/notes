# Machine Learning

## Questions

* How do we determine the optimal learning rate?
  * Idea: The smallest possible without becoming too slow?

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

