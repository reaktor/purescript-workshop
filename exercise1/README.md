# Exercise #1: Types, functions, and Hacker News

## Task

The Hacker Reader app currently displays only a list of story IDs. The data for all of the stories is hard-coded in the app.

Modify the app to:
* display the story titles, URLs, points, author, and number of comments
* display the "rank" of the story (index in array)
  * Hint: the package `Data.Array` has functions for working with arrays

## Topics
* Build tools
* Basic syntax
* Working with `CSS` and `HTML` types
* Looking up and reading documentation

## Setup

Install the npm/Node version listed in .nvmrc. If you are using nvm, you can install it with
```
nvm install
```


Install Node and Bower dependencies, including PureScript and PureScript build tools:
```
npm install
```

Start the app for development:
```
npm start
```

Once the app has compiled, open [http://localhost:8080](http://localhost:8080) to see it. On file changes the project will be re-compiled and the browser will be refreshed. Change the text of the buttons in src/Main.purs, save the file, and verify that the button text is updated in the browser.

## Editor setup

You do not need to have any editor support, but it will be helpful to have your editor set up with a minimum of syntax highlighting and ideally in-line compiler errors as well.

For the Atom editor, you can set it up as follows:

- [Download and install Atom](https://atom.io/)
- Install the packages ide-purescript and language-purescript (under Edit -> Preferences -> Install)
- In Edit -> Preferences -> Packages -> ide-purescript -> Settings, tick the box for "Use npm bin directory".
- Select File -> Add Project Folder and select the directory of this git repo.
- Open src/Main.purs, add a syntax error, and verify that the IDE server has started and the syntax error is reported inline.

There is also support for Vim, Emacs, and other editors. [See the instructions here](https://github.com/purescript/documentation/blob/master/ecosystem/Editor-and-tool-support.md), but you are on your own.
