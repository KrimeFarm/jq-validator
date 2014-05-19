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
        var $formElements, $submit, $this, checkAllComplete, checkElemFull, checkIsMail, checkIsName, checkIsNumber, checkboxVerified, emailReg, errorsArray, fieldLenght, fieldMail, fieldNumber, fieldText, nameReg, numberReg, size;
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
            stringLenght = 0;
            return stringLenght;
          }
        };
        checkboxVerified = function(element) {
          var checkboxRequired, dataChecked;
          checkboxRequired = $(element).attr("data-requiredbox");
          if (checkboxRequired != null) {
            dataChecked = $(element).prop("checked");
            log("Checkbox is " + dataChecked);
            return dataChecked;
          } else {
            return true;
          }
        };
        fieldMail = function(element) {
          var isMail, ismail, mail;
          isMail = $(element).attr("data-mail");
          if (isMail != null) {
            mail = $(element).val();
            return ismail = checkIsMail(mail);
          } else {
            return ismail = true;
          }
        };
        fieldNumber = function(element) {
          var isNumber, isnumber, number;
          isNumber = $(element).attr("data-number");
          if (isNumber != null) {
            number = $(element).val();
            return isnumber = checkIsNumber(number);
          } else {
            return isnumber = true;
          }
        };
        fieldText = function(element) {
          var isText, istext, name;
          isText = $(element).attr("data-text");
          if (isText != null) {
            name = $(element).val();
            return istext = checkIsName(name);
          } else {
            return istext = true;
          }
        };
        checkElemFull = function(element) {
          var ischecked, ismail, isname, isnumber, issuedLength, value;
          issuedLength = fieldLenght(element);
          ismail = fieldMail(element);
          isname = fieldText(element);
          isnumber = fieldNumber(element);
          ischecked = checkboxVerified(element);
          log("data-length " + (fieldLenght()));
          log("issuedLength " + issuedLength);
          value = $(element).val();
          value = value.length;
          log("value is " + value);
          if (value >= issuedLength && ismail === true && isname === true && isnumber === true && ischecked === true) {
            $(element).addClass("checked").removeClass("error");
            return $(element).closest(".form-group").removeClass("has-error");
          } else {
            $(element).closest(".form-group").addClass("has-error");
            return $(element).removeClass("checked").addClass("error");
          }
        };
        size = $formElements.size();
        log("to check " + size);
        checkAllComplete = function(elements) {
          var elementsSize;
          elementsSize = $(elements).size();
          log("Elements Size is " + elementsSize + " to check " + size);
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
          var $theErrorField, isDataLength, isDataMail, isDataNumber, isDataText, theErrorFieldPlaceholder, theErrorFieldValue;
          if (settings.preventDefault) {
            e.preventDefault();
          }
          $formElements.each(function() {
            checkElemFull($(this));
            return checkAllComplete(".checked");
          });
          if ($(this).hasClass("submit-ready")) {
            settings.callback.call(this);
            return log("submit");
          } else {
            log("don't submit");
            $theErrorField = $(".error").first();
            $theErrorField.focus();
            theErrorFieldValue = $theErrorField.val();
            theErrorFieldPlaceholder = $theErrorField.attr("placeholder");
            isDataMail = $theErrorField.attr("data-mail");
            isDataText = $theErrorField.attr("data-text");
            isDataNumber = $theErrorField.attr("data-number");
            isDataLength = $theErrorField.attr("data-length");
            if (isDataMail != null) {
              $theErrorField.val("").attr("placeholder", errorsArray[0].val);
            } else if (isDataText != null) {
              $theErrorField.val("").attr("placeholder", errorsArray[1].val);
            } else if (isDataNumber != null) {
              $theErrorField.val("").attr("placeholder", errorsArray[2].val);
            } else if (isDataLength != null) {
              $theErrorField.val("").attr("placeholder", errorsArray[3].val.first + (" " + isDataLength + " ") + errorsArray[3].val.second);
            } else {
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
