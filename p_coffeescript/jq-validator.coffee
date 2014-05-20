$ = jQuery

$.fn.extend
  jqValidator: (options) ->
    # Default settings
    settings =
      debug: true # debug option for console.log
      preventDefault: true # True to prevent submit action when button is pressed and when button is a type="submit"
      buttonClass: ".btn" # The class of the submit button
      placeholderTimeout: 2000 # The timeout placeholder animation
      errorsFile: "configuration/errors-en.json"
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
      $formElements = $("input:not([type=\"radio\"]):not([type=\"button\"]), textarea, select", $this)
      # $formCheckbox = $("input[type=\"checkbox\"]", $this)
      # $formRadio = $("input[type=\"radio\"]", $this)
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
          stringLenght = dataLength
          return stringLenght
        else
          return null

      checkboxVerified = (element) ->
        checkboxRequired = $(element).attr "data-requiredbox"
        if checkboxRequired?
          dataChecked = $(element).prop "checked"
          # Debug
          # log "Checkbox is #{dataChecked}"

      fieldMail = (element) ->
        isMail = $(element).attr "data-mail"
        if isMail?
          mail = $(element).val()
          ismail = checkIsMail(mail)
        else
          return null

      fieldNumber = (element) ->
        isNumber = $(element).attr "data-number"
        if isNumber?
          number = $(element).val()
          isnumber = checkIsNumber(number)
        else
          return null

      fieldText = (element) ->
        isText = $(element).attr "data-text"
        if isText?
          name = $(element).val()
          istext = checkIsName(name)
        else
          return null


      controlClass = (element, type, checkme) ->
        if checkme is true
          $(element)
            .addClass "checked"
            .removeClass "#{type}-field-error"
          $(element).closest(".form-group").removeClass "has-error"
        else
          $(element).closest(".form-group").addClass "has-error"
          $(element)
            .removeClass "checked"
            .addClass "#{type}-field-error"

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
        isname = fieldText(element)
        isnumber = fieldNumber(element)
        ischecked = checkboxVerified(element)

        # Debug
        # log "issuedLength #{issuedLength}"

        # This verify the length of
        # the input field value
        value = $(element).val()
        value = value.length

        # Debug
        # log "value is #{value}"

        # Now check the whole lot of data- attribute
        # and if the field is compiled as requested

        # Check while data-lenght present
        # if the actual value is correct.
        # The order right now is strategic, the last
        # is the most important and always
        # has the precendence.

        if issuedLength? and issuedLength <= value
          controlClass(element, "length", true)
        else
          controlClass(element, "length", false)

        if ismail?
          controlClass(element, "mail", ismail)

        if isname?
          controlClass(element, "name", isname)

        if isnumber?
          controlClass(element, "number", isnumber)

        # The checkbox wich is only controlled for
        # visual error management, aka red colored
        # label.
        if ischecked?
          controlClass(element, "checkbox", ischecked)



      # The number of controlled
      # form elements.
      size = $formElements.size()

      # Debug
      # log "to check #{size}"

      # The checkAllComplete verifies that
      # all controllable input fields are
      # controlled, using ".checked" class
      # to control the correct completion.
      checkAllComplete = (elements) ->
        # The number of the ".checked" fields
        elementsSize = $(elements).size()
        # Debug
        # log "Elements Size is #{elementsSize} to check #{size}"
        if elementsSize is size
          $(settings.buttonClass).addClass "submit-ready"
        else
          $(settings.buttonClass).removeClass "submit-ready"


      # jQuery $.getJSON to transform
      # errors.json file into an array
      # which contains all the errors
      # that will be displayed in form
      # fields placeholders.
      errorsArray=[]
      $.getJSON settings.errorsFile, (data) ->
        $.each data, (key, val) ->
          errorsArray.push
            key: key
            val: val
          return

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
          # Debug
          # log "submit"

          # This is the callback function
          # which can be used to fire another
          # function like an Ajax submission
          # when the form is fully compiled

          settings.callback.call(this)
        else
          # Few checks to be run when the
          # button is clicked to do some
          # magic animations when the form
          # is NOT correctly compiled

          # Debug
          # log "don't submit"

          $theErrorField = $("[class$=-field-error]").first()
          $theErrorField.focus()
          theErrorFieldValue = if $theErrorField.val() isnt "" then $theErrorField.val() else null
          theErrorFieldPlaceholder = $theErrorField.attr "placeholder"

          log "is the placeholder: #{theErrorFieldPlaceholder}"
          log "is the value: #{theErrorFieldValue}"

          # Check the error
          isDataMail = $theErrorField.hasClass "mail-field-error"
          isDataText = $theErrorField.hasClass "text-field-error"
          isDataNumber = $theErrorField.hasClass "number-field-error"
          isDataLength = $theErrorField.hasClass "length-field-error"
          isDataCheckbox = $theErrorField.attr "checkbox-field-error"

          # Get the "data-lenght" to use into the errorå
          theDataLenght = $theErrorField.attr "data-length"

          # Print the right error depending on
          # what the error is displayed by its class

          # Data -length error
          if isDataLengt
            if theDataLenght > 1
              $theErrorField.val("").attr "placeholder", errorsArray[3].val.first + " #{theDataLenght} " + errorsArray[3].val.second
            else
              $theErrorField.val("").attr "placeholder", errorsArray[4].val

          # Data -mail error
          if isDataMail
            $theErrorField.val("").attr "placeholder", errorsArray[0].val

          # Data -text error
          if isDataText
            $theErrorField.val("").attr "placeholder", errorsArray[1].val

          # Data -number error
          if isDataNumber
            $theErrorField.val("").attr "placeholder", errorsArray[2].val

          # Perform a switch between value and placeholder
          # or vice versa, depends on the value inside the
          # input field
          setTimeout ->
            if theErrorFieldValue?
              $theErrorField.val(theErrorFieldValue)
            else
              $theErrorField.attr "placeholder", theErrorFieldPlaceholder
          , settings.placeholderTimeout

          # Call a function to be submitted
          # when the form is not correctly
          # compiled
          settings.error.call(this)



  ##
  # by Alessandro Vioni AKA genoma
  # for Krimefarm spring 2014
  ##
