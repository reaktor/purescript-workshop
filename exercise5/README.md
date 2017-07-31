# Exercise #5: Decoding JSON

## Task

The Hacker News API data actually comes as a JSON string. The JSON string you might receive for the same items we have been working is now defined in the code.
* Get the initial story data by decoding it from the JSON string instead of using the provided data.

Useful packages: `purescript-foreign-generics` (`decodeJSON`)

You'll likely want to use these JSON options for decoding:
```
opts = defaultOptions { unwrapSingleConstructors = true }
```

## Topics
* Generic decoding
