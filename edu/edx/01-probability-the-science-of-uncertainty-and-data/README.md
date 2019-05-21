# 6.431x: Probability - The Science and Uncertainty of Data

* Course 6.431x
* Graduate level version of 6.041x.
* Same level, breadth, and depth of residential MIT offering.
* 12 hours / week average.

* Textbook (recommended)
  * Probability, 2nd edition, by Bertsekas and Tsitsiklis, Athena Scientific,
    2008


---

## Unit 0: Overview

### Course Overview

#### Objectives

* Introduce probability concepts
* Introduce mathematical tools / thinking
* Calculus and mental concentration is all you need. ;)

* Not an introductory / overview class. Expected to be able to apply what you
  learn.

#### Why study probability?

* Probability has become a key part of science
  * Traditionally, math, physics, and chemistry make up scientific literacy.
  * Today, Probability is a part of scientific literacy.
    * Systems are becoming more complex. You can't guarantee how systems are going
      to behave with certainty.
    * Information society. Data is critical. The goal of data is to tell us
      something we didn't know. You need to understand data.
    * The world is uncertain. It calls for probabilistic models.

* Probability is everywhere!
  * Physics (quantum)
  * Biology (evolution)
  * Finance (markets)
  * Transportation (random distractions, weather, accidents)
  * Social network trends


#### Course Contents

1-5 undergraduate statistics class material.

* Units 1-3: Basic Probability (Ch. 1)
* Unit 4: Discrete random variables (Ch 2)
* Unit 5: Continuous random variables (Ch 3)
* Unit 6: Further (intro) topics (Ch 1)
* Unit 7: Bayesian inference (Ch. 8)
* Unit 8: Limit theorms and statistics (Ch. 5, 9)
* Unit 9: Random arrival processes (Ch 6)
* Unit 10: Markov Chains (Ch 7)

### Course Introduction, Objectives, and Study Guide

#### 1. Introduction

* Intro to probabilistic models, including random processes and basic elements
  of statistical inference.

* Probabilistic modeling and the related field of statistical inference are keys
  to analyzing data and making scientifically sound predictions.

* This course covers basic probability concepts
  * Multiple discrete or continuous random variables, expectations, and
    conditional distributions.
  * Laws of large numbers
  * Main tools of bayesian inference models
  * Intro to random processes (Poisson processes and Markov chains)

#### Objectives

 * Master basic concepts of probabilistic models.
 * Concepts behind Bayesian and classical inference.
 * Familiarity with how to apply inference methods.

 * Become familiar with probability distributions.
 * Learn how to use conditioning to simplify analysis of complicated models.
 * Understand conditional expectation and it's role in inference.
 * Understand the law of large numbers.
 * Basic inference methodologies (Bernoulli and Poisson)
* Learn how to formulate simple dynamical models as Markov chains and analyze
  them.

#### Study Guide

* Do the problems!

#### Standard notation

* Always use `*` explicitly. i.e., (2*n), not (2n)
* Use ^ for exponents (`n^2`, `n^(x+1)`)
* Square roots: `sqrt(1)`
* Use `e` for the base of the natural logarithm, `pi` for pi.
* Use `ln` rather than `log`.


---

## Unit 1: Probability Models and Axioms

### Lecture 1: Probability Models and Axioms

* We need to make predictions and decisions under uncertainty.
* Models help predict future events by analyzing data.
* The course is mathematically based, but requires intuition.
* Life is uncertain!

* A **probabilistic model** is a quantitative description of a situation, phenomenon
  or experiment whose outcome is uncertain.

* Sample space
  * The outcomes of the experiment.
* Probability laws
  * Assigns probability to outcomes or collections of outcomes.
* Axioms
  * The properties probabilities have to follow. Like probability
    cannot be negative.
* Examples
  * Discrete
  * Continuous


#### Sample Space

* A sample space is the set of possible outcomes (Omega).
  * Each element is mutually exclusive.
    * At the end of the experiment, there is only one possible outcome.
  * Collectively exhaustive.
    * The outcome must be one of the elements in the sample space.
  * At the right granularity.

  * The right sample space depends on what you want to answer.
    * You may want to add or remove variables to the experiment depending on
      what you are trying to measure.
      * Example:
        * If you are trying to predict on time arrival, perhaps you need to use
          on time departure.
        * If you feel that weather impacts on time arrival, you want to include
          weather as well.
    * The set of variables you use in your experiment make up the sample space.

* Discrete / finite sample space
  * You have a fixed set of outcomes.
  * Example: Two rolls of a 4 sided die. Your sample space is (4 x 4 == 16)

* When you have an experiment with several stages, diagram it out as a tree.
  * The root is where you start. The sample set is the set of leaves.

* Infinite / continuous
  * Outcomes are not fixed. You could have an infinite number of values.
  * For example, measuring the length of a dart throw in millimeters.
  * The probability of an individual point in an infinitely continuous sample
    space is `0`.

#### Probability Axioms

* In an infinite sample space, the probability of an individual point occurring
  is `0`.
* When dealing with infinite sample spaces, you want to group a range of points
  together.
  * Example: What is the probability of hitting the top 1/2 of the sample space?
* A subset of the sample space is called an `Event`.
  * "Event A" is the top 1/2 of the sample space.

* Ω Omega (Sample Space)
* ∪ Union
* ∩ Intersection

* A ∪ B == Union == Elements that belong to A, B, or both.
* A ∩ B == Intersection == Elements that belong in A *and* B.

* Probability Axioms
  * Non-negativity: P(A) >= 0
  * Normalization: P(Ω) == 1
  * (Finite) Additivity:
    * If A ∩ B = ∅ (Empty Set - A and B are *disjoint*)
    * Then P(A ∪ B) = P(A) + P(B)

* Consequences of Axioms
  * A







