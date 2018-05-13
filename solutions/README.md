# Exercise #1: Types and functions

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

Compile app and run tests (re-running on changes):
```
npm run test:watch
```

There is one failing test. Write code to make it pass. Then uncomment the next test, watch it fail, and then make that one pass, too. Continue until there are no more tests to complete.

## Editor setup

Editor support is not necessary but is quite useful for tools like syntax highlighting, in-line compiler errors, and automatic imports.

For the Atom editor, you can set it up as follows:

- [Download and install Atom](https://atom.io/)
- Install the packages ide-purescript and language-purescript (under Edit -> Preferences -> Install)
- In Edit -> Preferences -> Packages -> ide-purescript -> Settings, tick the box for "Use npm bin directory".
- Select File -> Add Project Folder and select the directory of this git repo.
- Open src/Main.purs, add a syntax error, and verify that the IDE server has started and the syntax error is reported inline.

There is also support for Vim, Emacs, and other editors. [See the instructions here](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md), but you are on your own for the other editors.