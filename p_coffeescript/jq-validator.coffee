$ = jQuery

$.fn.extend
  jqValidator: (options) ->
    # Default settings
    settings =
      debug: true # debug option for console.log
      preventDefault: true # True to prevent submit action when button is pressed and when button is a type="submit"
      buttonClass: ".btn" # The class of the submit button
      callback: () -> # callback called when the form is submitted
      error: () -> # call a function if the form is not compiled correctly

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
        if value >= issuedLength and ismail is true and isname is true and isnumber is true
          $(element)
            .addClass "checked"
            .removeClass "error"
          $(element).closest(".form-group").removeClass "has-error"
        else
          $(element).closest(".form-group").addClass "has-error"
          $(element)
            .removeClass "checked"
            .addClass "error"



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
      # $formElements.on "change keyup focus", ->
      #   checkElemFull($(this))
      #   checkAllComplete(".checked")

      # Start the check of every controlled field
      # and preventDefault if required by settings
      $(settings.buttonClass).click (e) ->
        e.preventDefault() if settings.preventDefault

        # Control every required field
        $formElements.each ->
          checkElemFull($(this))
          checkAllComplete(".checked")

        if $(this).hasClass "submit-ready"
          # This is the callback function
          # which can be used to fire another
          # function like an Ajax submission
          settings.callback.call(this)
          # Debug
          log "submit"
        else
          # Debug
          log "don't submit"

          # Few checks to be run when the
          # button is clicked to do some
          # magic animation
          $theErrorField = $(".error").first()
          $theErrorField.focus()
          theErrorFieldValue = $theErrorField.val()
          theErrorFieldPlaceholder = $theErrorField.attr "placeholder"

          # Write the right val() into the required field
          # eg: if email or not
          isDataMail = $theErrorField.attr "data-mail"

          if isDataMail?
            $theErrorField.val("").attr "placeholder", "Wrong email address"
          else
            $theErrorField.val("").attr "placeholder", "This field is required"

          # Perform a switch between value and placeholder
          setTimeout ->
            $theErrorField.val(theErrorFieldValue)
          , 2000


          # Call a function to be submitted
          # when the form is not correctly
          # compiled
          settings.error.call(this)



  ##
  # by Alessandro Vioni AKA genoma
  # for Krimefarm spring 2014
  ##
