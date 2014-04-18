$ = jQuery

$.fn.extend
  jqValidator: (options) ->
    # Default settings
    settings =
      debug: false # debug option for console.log
      isForm: false # False for form not wrapper in <form></form> (.net), True for correct form wrapping
      buttonClass: ".btn" # The class of the submit button
      personalized_error: false # true for give personalized callback functions in case of wrong or correct form compilation
      correct_function: () -> # function called if true personalized_error when a field is compiled correctly
      error_function: () -> # function called when the form is not compiled in the right way
      callback: () -> # callback called when the form is submitted

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
      emailReg = /[^\s@]+@[^\s@]+\.[^\s@]+/



      # Put the regular expressions
      # in a function that is used
      # later with data- attributes
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

        # Now check the whole lot of data- attribute
        # and if the field is compiled as requested
        if value > issuedLength and ismail is true and isname is true and isnumber is true
          $(element).addClass "checked"
          if settings.personalized_error
            settings.correct_function.call(this)
          else
            $(element).closest(".form-group").removeClass "has-error"
        else
          if settings.personalized_error
            settings.error_function.call(this)
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
  # by Alessandro Vioni AKA genoma
  # for Krimefarm spring 2014
  ##
