# Exercise #1: Types, functions, and stories

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

Install Node and Bower dependencies, including PureScript and PureScript build tools:
```
npm install
```

Start the app for development:
```
npm start
```

Once the app has compiled, open [http://localhost:8080](http://localhost:8080) to see it.
On file changes the project will be re-compiled and the browser will be refreshed. Change the text of the buttons in `src/Main.purs`, save the file, and verify that the button text is updated in the browser.
