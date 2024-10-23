import 'package:get/get.dart';

class Validation {
  static validateEmail(String email) {
    return GetUtils.isEmail(email);
  }

  static validatePassword(String password) {
    final passwordRegExp = RegExp(r'^[a-zA-Z0-9.!@#><*~]');
    return passwordRegExp.hasMatch(password);
  }

  static validateName(String name) {
    final nameRegExp = RegExp(r"^[a-zA-Za-z]");
    return nameRegExp.hasMatch(name);
  }

  static phoneNumberValidation(String phone) {
    final phoneRegExp = RegExp(r'^[+0-9]');
    if (phoneRegExp.hasMatch(phone) && phone.length > 9) {
      return true;
    } else {
      return false;
    }
  }

  static numberValidation(String number) {
    final phoneRegExp = RegExp(r'^[0-9]');
    return phoneRegExp.hasMatch(number);
  }
}
