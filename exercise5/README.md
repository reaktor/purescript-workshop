## Exercise 5: Pux web application

### Setup

Install Node and psc-package dependencies, including PureScript itself and PureScript build tools:

```
npm install
```

### Exercise

In the final exercise, we add features to a front end Pux web application. The application source code is in the [exercises/src/] directory and can be compiled and bundled by running

```
npm start
```

The web application can be viewed by opening the file [exercises/public/index.html](exercises/public/index.html) in your browser. The source code will be recompiled and re-bundled on changes, and changes can be viewed in the browser by refreshing the page.

#### Task 1

The current application displays only the ID, points, and score of selected Hacker News items. Update the application to display Hacker News item titles and to link to the shared URL.

The following functions may be useful:

```
import Text.Smolder.HTML (a)
import Text.Smolder.HTML.Attributes (href)
```

#### Task 2

Display the author and number of comments in the tag line.

#### Task 3

Add an input box that filters the items in the list to display only those with text matching what is in the input box.