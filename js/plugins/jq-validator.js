(function() {
  var $;

  $ = jQuery;

  $.fn.extend({
    jqValidator: function(options) {
      var log, settings;
      settings = {
        debug: true,
        preventDefault: true,
        buttonClass: ".btn",
        placeholderTimeout: 2000,
        errorsLog: "configuration/errors-en.json",
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
          var dataLength, ismail, stringLenght;
          dataLength = $(element).attr("data-length");
          if (dataLength != null) {
            stringLenght = dataLength;
            return stringLenght;
          } else {
            return ismail = null;
          }
        };
        checkboxVerified = function(element) {
          var checkboxRequired, dataChecked;
          checkboxRequired = $(element).attr("data-requiredbox");
          if (checkboxRequired != null) {
            dataChecked = $(element).prop("checked");
            return dataChecked;
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
            return isnumber = null;
          }
        };
        fieldText = function(element) {
          var isText, istext, name;
          isText = $(element).attr("data-text");
          if (isText != null) {
            name = $(element).val();
            return istext = checkIsName(name);
          } else {
            return istext = null;
          }
        };
        controlClass = function(element, checkme) {
          if (checkme === true) {
            $(element).addClass("checked").removeClass("error");
            return $(element).closest(".form-group").removeClass("has-error");
          } else {
            $(element).closest(".form-group").addClass("has-error");
            return $(element).removeClass("checked").addClass("error");
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
            controlClass(element, true);
          } else {
            controlClass(element, false);
          }
          if (ismail != null) {
            controlClass(element, ismail);
          }
          if (isname != null) {
            controlClass(element, isname);
          }
          if (isnumber != null) {
            controlClass(element, isnumber);
          }
          if (ischecked != null) {
            return controlClass(element, ischecked);
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
        $.getJSON(settings.errorsLog, function(data) {
          return $.each(data, function(key, val) {
            errorsArray.push({
              key: key,
              val: val
            });
          });
        });
        return $(settings.buttonClass).click(function(e) {
          var $theErrorField, isDataCheckbox, isDataLength, isDataMail, isDataNumber, isDataText, theErrorFieldPlaceholder, theErrorFieldValue;
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
            $theErrorField = $(".error").first();
            $theErrorField.focus();
            theErrorFieldValue = $theErrorField.val() !== "" ? $theErrorField.val() : null;
            log(theErrorFieldValue);
            theErrorFieldPlaceholder = $theErrorField.attr("placeholder");
            isDataMail = $theErrorField.attr("data-mail");
            isDataText = $theErrorField.attr("data-text");
            isDataNumber = $theErrorField.attr("data-number");
            isDataLength = $theErrorField.attr("data-length");
            isDataCheckbox = $theErrorField.attr("data-requiredbox");
            if (isDataLength != null) {
              $theErrorField.val("").attr("placeholder", errorsArray[3].val.first + (" " + isDataLength + " ") + errorsArray[3].val.second);
            }
            if (isDataMail != null) {
              $theErrorField.val("").attr("placeholder", errorsArray[0].val);
            }
            if (isDataText != null) {
              $theErrorField.val("").attr("placeholder", errorsArray[1].val);
            }
            if (isDataNumber != null) {
              $theErrorField.val("").attr("placeholder", errorsArray[2].val);
            }
            if (isDataCheckbox != null) {
              $theErrorField.val("").attr("placeholder", errorsArray[4].val);
            }
            setTimeout(function() {
              if (theErrorFieldValue != null) {
                return $theErrorField.attr("placeholder", theErrorFieldPlaceholder);
              } else {
                return $theErrorField.val(theErrorFieldValue);
              }
            }, settings.placeholderTimeout);
            return settings.error.call(this);
          }
        });
      });
    }
  });

}).call(this);
