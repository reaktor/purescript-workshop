# PureScript for Working Stiffs

This is a workshop introduction to the PureScript language.

The goal of this workshop is to get attendees started with practical web app development using PureScript. The focus is on application of PureScript concepts over theoretical understanding.

## Pre-requisites
No prior PureScript knowledge is required. Some familiarity with JavaScript (or at least JavaScript tooling) or functional programming is helpful.

## Initial setup

[See the README for Exercise 1 for the initial setup.](exercise1)

## Outline

The practical task of the workshop is to build a Hacker News Reader app. This is a front-end web application for reading links and comments from Hacker News.

There are a number of exercises to complete, in sequence, to build up a Hacker news reader. Each exercise is preceded by a short presentation of related PureScript language concepts and the project setup and followed by a presentation of the solution. Each exercise contains the solution to the previous exercise, plus in some cases a small amount of setup for the next exercise.

1. Brief introduction
1. Exercises
    1. [Exercise #1](./exercise1): Types, functions, and Hacker News
    1. [Exercise #2](./exercise2): ADTs, sorting, and filtering
    1. [Exercise #3](./exercise3): Time and the Foreign Function Interface (FFI)
    1. [Exercise #4](./exercise4): The Network is Calling for Monads
1. Conclusion & discussion

The presentation slides can be viewed [here](https://reaktor.github.io/purescript-workshop). The source code for the slides is [in the slides directory](./slides).

## Helpful Resources

* [The PureScript Book](https://leanpub.com/purescript/read)
* [Pursuit](https://pursuit.purescript.org/)
  * PureScript package documentation
  * Recommendation: add a keyword search for Pursuit so that you can type e.g. `pu Maybe` to search Pursuit for `Maybe`.
* [Halogen library documentation](https://github.com/slamdata/purescript-halogen)
  * Halogen is the UI library used in this workshop.
* [Language Reference](https://github.com/purescript/documentation/blob/master/language/README.md)
  * The quick, show me the syntax version of "what can PureScript do"

