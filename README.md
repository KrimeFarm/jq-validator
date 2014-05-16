jq-validator (beta)
============

#### This software is still in development!

An easy to use jQuery validation plugin tailored for Bootstrap **beta**.

## Configurations

```coffeescript
      debug: false # debug option for console.log
      preventDefault: true # True to prevent submit action when button is pressed and when button is a type="submit"
      buttonClass: ".btn" # The class of the submit button
      callback: () -> # callback called when the form is submitted
      error: () -> # call a function if the form is not compiled correctly
```

## Custom data attributes

`data-lenght="3"` The minimum lenght of the string in the input field

`data-mail` The string needs to be an email

`data-number` The string has to be a number

`data-name` The string is letters only
