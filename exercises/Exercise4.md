## Exercise 4: The network is calling for monads

Run the following command from the `exercises` directory to compile and run the exercise. This will also re-compile the code and re-run the exercise when the code changes.

```
npm run exercise4
```

This should compile successfully and display one failing test in [test/Exercise4.purs](test/Exercise4.purs). Open that file in your editor and write code to make that test pass.

There are other tests or test suites within the same file prefixed by `skip`, as in `skipTest` and `skipSuite`. Once the first test has been passed, remove the `skip` portion from the next test, watch the test fail, and then write the code to make that pass, too. Repeat until you run out of tests.