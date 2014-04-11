jq-validator
============

An easy to use jQuery validation plugin compatible with .net projects and bootstrap.

## Configurations

```coffeescript
  settings =
    debug: false # debug option for console.log
    isForm: false # False for form not wrapper in <form></form> (.net), True for correct form wrapping
    buttonClass: ".btn" # The class of the submit button
    personalized_error: false # true for give personalized callback functions in case of wrong or correct form compilation
    correct_function: () -> # function called if true personalized_error when a field is compiled correctly
    error_function: () -> # function called when the form is not compiled in the right way
    callback: () -> # callback called when the form is submitted
```

## Custom data attributes

`data-lenght="3"` The minimum lenght of the string in the input field

`data-mail` The string needs to be an email

`data-number` The string has to be a number

`data-name` The string is letters only
