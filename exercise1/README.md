# Exercise #1: Types, functions, and Hacker News

## Setup

Install the npm/Node version listed in .nvmrc. If you are using nvm, you can install it with
```
nvm install
```

Install Node and psc-package dependencies, including PureScript itself and PureScript build tools:
```
npm install
npm run psc -- install
```

Build the app for development (recompiling on changes):
```
npm run compile:watch
```

Once the app has compiled, open the `public/index.html` file in your browser to see the app. On file changes the project will be re-compiled. Change the text of the header title in src/Main.purs, save the file, and verify that the text is updated in the browser.

## Editor setup

Editor support is not necessary but is quite useful for tools like syntax highlighting, in-line compiler errors, and automatic imports.

For the Atom editor, you can set it up as follows:

- [Download and install Atom](https://atom.io/)
- Install the packages ide-purescript and language-purescript (under Edit -> Preferences -> Install)
- In Edit -> Preferences -> Packages -> ide-purescript -> Settings, tick the box for "Use npm bin directory".
- Select File -> Add Project Folder and select the directory of this git repo.
- Open src/Main.purs, add a syntax error, and verify that the IDE server has started and the syntax error is reported inline.

There is also support for Vim, Emacs, and other editors. [See the instructions here](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md), but you are on your own for the other editors.

## Warm-up

To get you started writing PureScript, there are a few warm-up puzzles in `test/Main.purs`. Run `npm run test:watch` to kick off tests, uncomment each test in turn, watch it fail, then write the code to make it turn green.

## Task

The Hacker Reader app currently displays only a list of story IDs. The data for all of the stories is hard-coded in the app.

Modify the app to:
* display the story titles, URLs, points, author, and number of comments
* display the "rank" of the story (index in array)
  * Hint: the package `Data.Array` has functions for working with arrays

## Topics
* Build tools
* Basic syntax
* Working with Halogen DOM types
* Looking up and reading documentation