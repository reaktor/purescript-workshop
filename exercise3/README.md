# Exercise #3: Logging and type classes

## Task

Update the Hacker Reader app to:
* log each event as it is processed, by defining an instance of the Show type class

  I.e. so you can log events with `log (show event)`
  
* log each state of the app, by defining an instance for the Show type class

  Hint: you can't define a type class for a record, but you can for a newtype that wraps a record e.g. `newtype State = State {...}`

## Topics
* Type classes
