jq-validator (beta)
============

An easy to use jQuery validation plugin tailored for Bootstrap **beta**.

## What it provides

This plugin is an easy to use and [Bootstrap](http://getbootstrap.com/) ready plugin for form field verification. It is still in heavy development, some functions are incomplete, but it does the simple job to give a nice visual feedback to the user ( like in [Krimefarm form](http://www.krimefarm.com/) ).

## How to use

Quite simply you call the plugin with the options written below in this document.

```coffeescript
$ ->
  $(".myform").jqValidator
    preventDefault: true # True to prevent submit action when button is pressed and is a type="submit"
    buttonClass: ".btn" # The class of the submit button
    placeholderTimeout: 2000 # The timeout placeholder animation
    errorsLog: "configuration/errors-en.json" # The .json configuration file
    callback: () -> # callback called when the form is submitted
    error: () -> # call a function if the form is not compiled correctly
    return
```

## errors-en.json ?

While supporting multilanguage the relative option provide an easy to implement **error translation** for different languages.

```json
{
  "mail": "You need to use a vaild email address!",
  "text": "You need to use only letters!",
  "numbers": "You need to use only numbers!",
  "length": {
    "first": "This field needs to be",
    "second": "letters long!"
  },
  "general": "This field is required!"
}
```
This should be pretty explanatory, translate in any language you need to support and add a new file called `errors-*language*.js`, the rest is pure js _(check the browser language and launch different instances of **jqValidator** with different json files ... easy peasy)_.

## Custom data attributes

As everything in this plugin should be easy, the control is based on the **_["custom data attributes"](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes#data-*)_**.

- **`data-lenght="3"` The minimum length of the string in the input field _(1 means the field is required)_**
- **`data-mail` The string needs to be an email**
- **`data-number` The string has to be a number**
- **`data-name` The string is letters only**
- **`data-requiredbox` The checkbox is required**


## TODO

The development could be a little slow, but there are a lot of improvements planned for the next release before this plugin will be marked as **stable**.

- [ ] Better error management
- [ ] Refactoring error check functions
