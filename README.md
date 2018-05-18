# PureScript for Working Stiffs

This is a workshop introduction to the PureScript language.

The goal of this workshop is to get attendees started with practical web app development using PureScript. The focus is on application of PureScript concepts over theoretical understanding.

## Pre-requisites
No prior PureScript knowledge is required. Some familiarity with JavaScript (or at least JavaScript tooling) or functional programming is helpful.

## Outline

This workshop has a series of exercises building up to creating a Hacker News Reader app in the final exercises. The first four exercises are a sequence of TDD-style exercises designed to illustrate various aspects of the PureScript language and ecosystem. The fifth exercise builds on a small web application built using the Pux UI library.

Each exercise is preceded by a short presentation of related PureScript language concepts and the project setup and is followed by a presentation of the solution. Solutions for all exercises are contained in the [solutions](./solutions) directory.

1. Introduction
1. Exercises
    1. Exercise #1: Types, functions, and Hacker News
    1. Exercise #2: ADTs, sorting, and filtering
    1. Exercise #3: Time and the Foreign Function Interface (FFI)
    1. Exercise #4: Type classes
    1. Exercise #5: Pux web application
1. Conclusion & discussion

The presentation slides can be viewed [here](https://reaktor.github.io/purescript-workshop-breakpoint). The source code for the slides is [in the slides directory](./slides).

## Editor setup

Editor support is not necessary but is quite useful for tools like syntax highlighting, in-line compiler errors, and automatic imports.

For the Atom editor, you can set it up as follows:

- [Download and install Atom](https://atom.io/)
- Install the packages ide-purescript and language-purescript (under Edit -> Preferences -> Install)
- In Edit -> Preferences -> Packages -> ide-purescript -> Settings, tick the box for "Use npm bin directory".
- Select File -> Add Project Folder and select the directory of this git repo.
- Open src/Main.purs, add a syntax error, and verify that the IDE server has started and the syntax error is reported inline.

There is also support for Vim, Emacs, and other editors. [See the instructions here](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md), but you are on your own for the other editors.

## Getting started

Run all of the following commands from the `exercises` directory.

Install the npm/Node version listed in .nvmrc. If you are using nvm, you can install it with
```
nvm install
```

Install Node and psc-package dependencies, including PureScript itself and PureScript build tools:
```
npm install
```

## Exercises 1-4

Run the following command from the `exercises` directory to compile the first exercises and run tests. This will re-compile the code and re-run tests whenever the code changes.
```
npm run exercises:all
```

This should compile successfully and display one failing test in [exercises/test/Exercise1.purs](exercises/test/Exercise1.purs). Open that file in your editor and write code to make that test pass. There are other tests or test suites within the same file prefixed by `skip`, as in `skipTest` and `skipSuite`. Remove the `skip` portion from the next test to proceed. Now make that test pass.

The first four exercises correspond to four test files in the `exercises/test/` directory.

## Exercise 5: Pux web application

In the final exercise, we add features to a front end Pux web application. The application source code is in the [exercises/src/] directory and can be compiled and bundled by running

```
npm run exercise5
```

The web application can be viewed by opening the file [exercises/public/index.html](exercises/public/index.html) in your browser. The source code will be recompiled and re-bundled on changes, and changes can be viewed in the browser by refreshing the page. The specific tasks themselves are described in the [slides](https://reaktor.github.io/purescript-workshop-breakpoint).

## Helpful Resources

* [The PureScript Book](https://leanpub.com/purescript/read)
* [Pursuit](https://pursuit.purescript.org/)
  * PureScript language and library API documentation
* [Pux library documentation](http://purescript-pux.org/docs/architecture/)
  * Pux is the UI library used in this workshop.
* [PureScript Language Reference](https://github.com/purescript/documentation/blob/master/language/README.md)
  * The quick, show me the syntax version of "what can PureScript do"

