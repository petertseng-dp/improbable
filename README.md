# Mission Improbable

Calculate some probabilities.

[![Build Status](https://travis-ci.org/petertseng-dp/improbable.svg?branch=master)](https://travis-ci.org/petertseng-dp/improbable)

# Notes

I used integer percentages rather than decimals for my inputs.

Probably more time was spent thinking up a design than coding.
My main motivation was to think through how I, as a human, would work through the example problem given (input/sample2).

The notation:

* `P(A)` for the probability of an event happening.
* `P(!A)` for the probability of an event not happening.
* `P(A & B)` for the probability of both events happening.
* `P(A + B)` for the probability of at least one event happening (not `P(A | B)` for the potential to confusion with conditional probability, though conditional probability is not discussed here).

The thought process:

* Given that `P(!A & !B & !C) = 0.1`, I would know `P(A + B + C) = 1.0 - 0.1 = 0.9`
* Given that `P(A & !B & !C) = 0.13` and the above inference, I would know `P(B + C) = 0.9 - 0.13 = 0.77`.
* `P(B + C) = P(B) + P(C) - P(B & C)`, meaning `0.77 = 0.7 + 0.27 - P(B & C)`

The useful part was to see that when we learn about `P(E)` and know about `P(E')` where `E` is a subset of `E'`, we can infer `P(E' - E)` or `P(E' & !E)`.
This is the general case of "When we learn `P(E), we can infer P(!E)`" - the specific case here is where `E' = S`.
Similarly, when we learn `P(E)` and know about a `P(E')` that is mutually exclusive with `E`, we can infer `P(E + E')`.
The rule about `P(B + C) = P(B) + P(C) - P(B & C)` did not need to be specifically implemented.

# Source

https://www.reddit.com/r/dailyprogrammer/comments/2vs1c6
