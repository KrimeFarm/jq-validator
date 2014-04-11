(function() {
  var $;

  $ = jQuery;

  $.fn.extend({
    jqValidator: function(options) {
      var log, settings;
      settings = {
        debug: false,
        isForm: false,
        buttonClass: ".btn",
        callback: function() {}
      };
      settings = $.extend(settings, options);
      log = function(msg) {
        if (settings.debug) {
          return typeof console !== "undefined" && console !== null ? console.log(msg) : void 0;
        }
      };
      return this.each(function() {
        var $formElements, $submit, $this, checkAllComplete, checkElemFull, checkIsMail, checkIsName, checkIsNumber, emailReg, fieldLenght, fieldMail, fieldName, fieldNumber, nameReg, numberReg, size;
        $this = $(this);
        $formElements = $("input, textarea, select", $this);
        $submit = $(settings.buttonClass, $this);
        nameReg = /^[A-Za-z]+$/;
        numberReg = /^[0-9]+$/;
        emailReg = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i;
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
            stringLenght = dataLength - 1;
            return stringLenght;
          } else {
            stringLenght = 0;
            return stringLenght;
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
        fieldName = function(element) {
          var isName, isname, name;
          isName = $(element).attr("data-name");
          if (isName != null) {
            name = $(element).val();
            return isname = checkIsName(name);
          } else {
            return isname = true;
          }
        };
        checkElemFull = function(element) {
          var ismail, isname, isnumber, issuedLength, value;
          issuedLength = fieldLenght(element);
          ismail = fieldMail(element);
          isname = fieldName(element);
          isnumber = fieldNumber(element);
          log("data-length " + (fieldLenght()));
          log("issuedLength " + issuedLength);
          value = $(element).val();
          value = value.length;
          log("value is " + value);
          if (value > issuedLength && ismail === true && isname === true && isnumber === true) {
            $(element).addClass("checked");
            return $(element).closest(".form-group").removeClass("has-error");
          } else {
            $(element).closest(".form-group").addClass("has-error");
            return $(element).removeClass("checked");
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
        $formElements.on("change keyup focus", function() {
          checkElemFull($(this));
          return checkAllComplete(".checked");
        });
        return $(settings.buttonClass).click(function(e) {
          if ($(this).hasClass("submit-ready")) {
            settings.callback.call(this);
            return log("submit");
          } else {
            if (settings.isForm) {
              e.preventDefault();
            }
            return log("don't submit");
          }
        });
      });
    }
  });

}).call(this);
