jq-validator (beta)
============

An easy to use jQuery validation plugin tailored for Bootstrap **beta**.

## What it provides

This plugin is an easy to use and [Bootstrap](http://getbootstrap.com/) ready plugin for form field verification. It is still in heavy development, some functions are incomplete, but it does the simple job to give a nice visual feedback to the user ( like in [Krimefarm form](http://www.krimefarm.com/) ).

## TODO
- [ ] Better error management
- [ ] Refactoring error check functions

## Configurations

```coffeescript
debug: false # Debug!
preventDefault: true # True to prevent submit action when button is pressed and is a type="submit"
buttonClass: ".btn" # The class of the submit button
placeholderTimeout: 2000 # The timeout placeholder animation
errorsLog: "configuration/errors-en.json" # The .json configuration file
callback: () -> # callback called when the form is submitted
error: () -> # call a function if the form is not compiled correctly
```

## Custom data attributes

**`data-lenght="3"` The minimum lenght of the string in the input field _(1 means the field is required)_**

**`data-mail` The string needs to be an email**

**`data-number` The string has to be a number**

**`data-name` The string is letters only**

**`data-requiredbox` The checkbox is required**
