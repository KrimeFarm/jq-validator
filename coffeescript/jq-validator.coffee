$ = jQuery

$.fn.extend
  jqValidator: (options) ->
    # Default settings
    settings =
      debug: false
      isForm: false
      buttonClass: ".btn"
      callback: () ->

    # Merge default settings with options.
    settings = $.extend settings, options

    # Simple logger.
    log = (msg) ->
      console?.log msg if settings.debug

    # _Insert magic here._
    return @each ()->

      $this = $(this)
      $formElements = $("input, textarea, select", $this)
      $submit = $(settings.buttonClass, $this)

      # Regular expressions
      # to check the validity
      # of the input form fields
      nameReg = /^[A-Za-z]+$/
      numberReg =  /^[0-9]+$/
      emailReg = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i



      # Put the regular expressions
      # in a function that is used
      # later with data-object HTML5
      checkIsMail = (input) ->
        pattern = new RegExp(emailReg)
        return pattern.test(input)

      checkIsNumber = (input) ->
        pattern = new RegExp(numberReg)
        return pattern.test(input)

      checkIsName = (input) ->
        pattern = new RegExp(nameReg)
        return pattern.test(input)



      # Create a series of functions
      # to write a number of variables
      # used in the main function
      # to validate the form, it uses
      # the regular expressions written
      # above
      fieldLenght = (element) ->
        dataLength = $(element).attr "data-length"
        if dataLength?
          stringLenght = dataLength - 1
          return stringLenght
        else
          stringLenght = 0
          return stringLenght

      fieldMail = (element) ->
        isMail = $(element).attr "data-mail"
        if isMail?
          mail = $(element).val()
          ismail = checkIsMail(mail)
        else
          ismail = true

      fieldNumber = (element) ->
        isNumber = $(element).attr "data-number"
        if isNumber?
          number = $(element).val()
          isnumber = checkIsNumber(number)
        else
          isnumber = true

      fieldName = (element) ->
        isName = $(element).attr "data-name"
        if isName?
          name = $(element).val()
          isname = checkIsName(name)
        else
          isname = true



      # The main function that
      # is fired when the form
      # is compiled and checks
      # the validity of its fields
      checkElemFull = (element) ->

        # Call the regex based functions
        # checking if the input field is
        # a number, string or an email.
        # The  "data-lenght=0" disable the length
        # check, disabling the main control
        # if anything else is not required.
        issuedLength = fieldLenght(element)
        ismail = fieldMail(element)
        isname = fieldName(element)
        isnumber = fieldNumber(element)

        # Debug scripts
        log "data-length #{fieldLenght()}"
        log "issuedLength #{issuedLength}"

        # This verify the length of
        # the input field value
        value = $(element).val()
        value = value.length

        # Debug
        log "value is #{value}"

        # Now check the whole lot of data-object
        # and if the field is compiled as requested
        if value > issuedLength and ismail is true and isname is true and isnumber is true
          $(element).addClass "checked"
          $(element).closest(".form-group").removeClass "has-error"
        else
          $(element).closest(".form-group").addClass "has-error"
          $(element).removeClass "checked"



      # The number to controlled
      # form elements.
      size = $formElements.size()

      # Debug
      log "to check #{size}"

      # The checkAllComplete verifies that
      # all controllable input fields are
      # controlled, using ".checked" class
      # to control the correct completion.
      checkAllComplete = (elements) ->
        # The number of the ".checked" fields
        elementsSize = $(elements).size()
        log "Elements Size is #{elementsSize} to check #{size}"
        if elementsSize is size
          $(settings.buttonClass).addClass "submit-ready"
        else
          $(settings.buttonClass).removeClass "submit-ready"


      # This fires on _complete, keyup, focus
      # the two principal control functions
      # verifying the form submission
      $formElements.on "change keyup focus", ->
        checkElemFull($(this))
        checkAllComplete(".checked")

      # To compel with .net if the isForm
      # is set to _false_ there are no consequences
      # but only one class is added to the button
      # which means is ready to be manipulated
      # by the framework, if is _true_ form submission
      # is prevented by e.preventDefault
      $(settings.buttonClass).click (e) ->
        if $(this).hasClass "submit-ready"
          # This is the callback function
          # which can be used to fire another
          # function like an Ajax submission
          settings.callback.call(this)
          # Debug
          log "submit"
        else
          e.preventDefault() if settings.isForm
          # Debug?
          log "don't submit"



  ##
  # by Alessandro Vioni AKA Jenoma
  # for Krimefarm spring 2014
  ##
