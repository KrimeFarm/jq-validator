(function() {
  var $;

  $ = jQuery;

  $.fn.extend({
    jqValidator: function(options) {
      var log, settings;
      settings = {
        debug: false,
        preventDefault: true,
        buttonClass: ".btn",
        placeholderTimeout: 2000,
        errorsFile: "configuration/errors-en.json",
        callback: function() {},
        error: function() {}
      };
      settings = $.extend(settings, options);
      log = function(msg) {
        if (settings.debug) {
          return typeof console !== "undefined" && console !== null ? console.log(msg) : void 0;
        }
      };
      return this.each(function() {
        var $formElements, $submit, $this, checkAllComplete, checkElemFull, checkIsMail, checkIsName, checkIsNumber, checkboxVerified, controlClass, emailReg, errorsArray, fieldLenght, fieldMail, fieldNumber, fieldText, nameReg, numberReg, size;
        $this = $(this);
        $formElements = $("input:not([type=\"radio\"]):not([type=\"button\"]), textarea, select", $this);
        $submit = $(settings.buttonClass, $this);
        nameReg = /^[A-Za-z]+$/;
        numberReg = /^[0-9]+$/;
        emailReg = /[^\s@]+@[^\s@]+\.[^\s@]+/;
        checkIsMail = function(input) {
          var pattern;
          pattern = new RegExp(emailReg);
          return pattern.test(input);
        };
        checkIsNumber = function(input) {
          var pattern;
          pattern = new RegExp(numberReg);
          return pattern.test(input);
        };
        checkIsName = function(input) {
          var pattern;
          pattern = new RegExp(nameReg);
          return pattern.test(input);
        };
        fieldLenght = function(element) {
          var dataLength, stringLenght;
          dataLength = $(element).attr("data-length");
          if (dataLength != null) {
            stringLenght = dataLength;
            return stringLenght;
          } else {
            return null;
          }
        };
        checkboxVerified = function(element) {
          var checkboxRequired, dataChecked;
          checkboxRequired = $(element).attr("data-requiredbox");
          if (checkboxRequired != null) {
            return dataChecked = $(element).prop("checked");
          }
        };
        fieldMail = function(element) {
          var isMail, ismail, mail;
          isMail = $(element).attr("data-mail");
          if (isMail != null) {
            mail = $(element).val();
            return ismail = checkIsMail(mail);
          } else {
            return null;
          }
        };
        fieldNumber = function(element) {
          var isNumber, isnumber, number;
          isNumber = $(element).attr("data-number");
          if (isNumber != null) {
            number = $(element).val();
            return isnumber = checkIsNumber(number);
          } else {
            return null;
          }
        };
        fieldText = function(element) {
          var isText, istext, name;
          isText = $(element).attr("data-text");
          if (isText != null) {
            name = $(element).val();
            return istext = checkIsName(name);
          } else {
            return null;
          }
        };
        controlClass = function(element, type, checkme) {
          if (checkme === true) {
            $(element).addClass("checked").removeClass("" + type + "-field-error");
            return $(element).closest(".form-group").removeClass("has-error");
          } else {
            $(element).closest(".form-group").addClass("has-error");
            return $(element).removeClass("checked").addClass("" + type + "-field-error");
          }
        };
        checkElemFull = function(element) {
          var ischecked, ismail, isname, isnumber, issuedLength, value;
          issuedLength = fieldLenght(element);
          ismail = fieldMail(element);
          isname = fieldText(element);
          isnumber = fieldNumber(element);
          ischecked = checkboxVerified(element);
          value = $(element).val();
          value = value.length;
          if ((issuedLength != null) && issuedLength <= value) {
            controlClass(element, "length", true);
          } else {
            controlClass(element, "length", false);
          }
          if (ismail != null) {
            controlClass(element, "mail", ismail);
          }
          if (isname != null) {
            controlClass(element, "name", isname);
          }
          if (isnumber != null) {
            controlClass(element, "number", isnumber);
          }
          if (ischecked != null) {
            return controlClass(element, "checkbox", ischecked);
          }
        };
        size = $formElements.size();
        checkAllComplete = function(elements) {
          var elementsSize;
          elementsSize = $(elements).size();
          if (elementsSize === size) {
            return $(settings.buttonClass).addClass("submit-ready");
          } else {
            return $(settings.buttonClass).removeClass("submit-ready");
          }
        };
        errorsArray = [];
        $.getJSON(settings.errorsFile, function(data) {
          return $.each(data, function(key, val) {
            errorsArray.push({
              key: key,
              val: val
            });
          });
        });
        return $(settings.buttonClass).click(function(e) {
          var $theErrorField, isDataCheckbox, isDataLength, isDataMail, isDataNumber, isDataText, theDataLenght, theErrorFieldPlaceholder, theErrorFieldValue;
          if (settings.preventDefault) {
            e.preventDefault();
          }
          $formElements.each(function() {
            checkElemFull($(this));
            return checkAllComplete(".checked");
          });
          if ($(this).hasClass("submit-ready")) {
            return settings.callback.call(this);
          } else {
            $theErrorField = $("[class$=-field-error]").first();
            $theErrorField.focus();
            theErrorFieldValue = $theErrorField.val() !== "" ? $theErrorField.val() : null;
            theErrorFieldPlaceholder = $theErrorField.attr("placeholder");
            log("is the placeholder: " + theErrorFieldPlaceholder);
            log("is the value: " + theErrorFieldValue);
            isDataMail = $theErrorField.hasClass("mail-field-error");
            isDataText = $theErrorField.hasClass("text-field-error");
            isDataNumber = $theErrorField.hasClass("number-field-error");
            isDataLength = $theErrorField.hasClass("length-field-error");
            isDataCheckbox = $theErrorField.attr("checkbox-field-error");
            theDataLenght = $theErrorField.attr("data-length");
            if (isDataLengt) {
              if (theDataLenght > 1) {
                $theErrorField.val("").attr("placeholder", errorsArray[3].val.first + (" " + theDataLenght + " ") + errorsArray[3].val.second);
              } else {
                $theErrorField.val("").attr("placeholder", errorsArray[4].val);
              }
            }
            if (isDataMail) {
              $theErrorField.val("").attr("placeholder", errorsArray[0].val);
            }
            if (isDataText) {
              $theErrorField.val("").attr("placeholder", errorsArray[1].val);
            }
            if (isDataNumber) {
              $theErrorField.val("").attr("placeholder", errorsArray[2].val);
            }
            setTimeout(function() {
              if (theErrorFieldValue != null) {
                return $theErrorField.val(theErrorFieldValue);
              } else {
                return $theErrorField.attr("placeholder", theErrorFieldPlaceholder);
              }
            }, settings.placeholderTimeout);
            return settings.error.call(this);
          }
        });
      });
    }
  });

}).call(this);
