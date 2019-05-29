# Unit 2: Conditioning and Independence

## Overview

This unit covers conditional probability. Conditional probability is the
probability of an event given that another event has occurred. For example, the
probability of being sick is 5%. The probability of being sick when you are next
to someone else who is sick (the other event, or condition), is 50%.

Consider an ethernet network. What is the probability a packet will be delivered
successfully from A -> B thru a handful of switches and routers? What is the
probability if one of the intermediate routers fails?

### Conditioning

* Revising a model using new information.
* Divide-and-conquer tools.

### Independence

* Independence describes an event which occurs that is unrelated to another
  event.

* Complex systems are typically made up of independent events.


## 1. Lecture 2 Overview

### Conditional Probability

This lecture looks into important tools to incorporate new evidence (conditions)
into a probability model.

* Multiplication rule
* Total probability theorem
* Bayes' rule (the basis for inference)


## 2. Conditional probabilities

P(A | B) = P(A ∩ B) / B(B)
Assume:
* P(A) = 5/12
* P(B) = 6/12
* P(A ∩ B) = 2/12
If we are told B has occurred, what is the likelihood that A has occurred?

P(A | B) = 2/12 / 6/12 == 2/6 == 1/3
P(B | B) = 1

## 4. A die roll example

Assume a 4 sided die

* Given B = min(x,y) == 2 (the minimum of x and y == 2)
* M = min(x, y) = 2

What is the probability of M = 1?
```
P(M = 1 | B) = 0
```
The probability of M = 1 is 0. Given that we *know* the min of x, y = 2, we
know that M = 1 can't occur.

What is the probability of M = 3?

```

```