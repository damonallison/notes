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

h(x) = O(0) + O(1)

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

By taking the derivative of the cost function (the slope) and move down.

At each iteration j, one should simultaneously update the parameters (O1, O2, O3).

The learning rate is the amount we move between different iterations of the
algorithm. If the learning rate is too small, it will take a lot of steps. If
too large, we may miss the minimum or start to diverge.

* Can we change the training rate based on the derivative?
  * We don't need to.  As we approach a local mimimum, gradient descent will
    take smaller steps.
* How to find the global optimum if you are at a local optimum?


### Gradient Descent for Linear Regression

Goal: Use gradient descent to mimium.

With linear regression, you'll only have one local optimum, the global optimum.

* "Batch" gradient descent. Batch means that at each step, we look at all training examples.
* Other approaches use a subset of all points at each step (Stocastic Gradient Descent?)

The normal equations method (from linear algebra) will find the global minimum without needing to use gradient descent. However, gradient descent will scale better than the normal equations method.

