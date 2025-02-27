import 'Strings.dart';

class Validator {
  static String validateEmail(String value) {
    String pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "Email is Required";
    }   else if (value.contains(' ')){
      return "Email cannot contains spaces";
    }else if (!regExp.hasMatch(value)) {
      return "Invalid email address. Please try again.";
    } else {
      return '';
    }
  }

  static String validatePassword(String value) {
    print(value);
    if (value.isEmpty) {
      return 'Please enter password';
    } else if (value.length < 4) {
      return "Please enter password";
    }

    else {
      return '';
    }
  }

  static String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Enter Phone Number";
    } else if (value.length != 10) {
      return "Enter valid phone number";
    } else if (!regExp.hasMatch(value)) {
      return "Phone Number must be digits";
    }
    return '';
  }

  static String otp(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Enter OTP";
    } else if (value.length != 1) {
      return "Enter valid OTP";
    } else if (!regExp.hasMatch(value)) {
      return "OTP must be digits";
    }
    return '';
  }

  static String validateName(String value) {
    String patttern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length < 2) {
      return "Enter Valid $firstName";
    }
    else if (value.contains(' ')){
      return "Username cannot contains spaces";
    }
    else if (!regExp.hasMatch(value)) {
      return "Enter Valid $firstName";
    }
    return '';
  }
  static String validateLName(String value) {
    String patttern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length < 2) {
      return "Enter Valid $lastName";
    }
    else if (value.contains(' ')){
      return "Lastname cannot contains spaces";
    }
    else if (!regExp.hasMatch(value)) {
      return "Enter Valid $lastName";
    }
    return '';
  }
  static String validateFName(String value) {
    String patttern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length < 2) {
      return "Enter Valid $lastName";
    }
    else if (value.contains(' ')){
      return "Firstname cannot contains spaces";
    }
    else if (!regExp.hasMatch(value)) {
      return "Enter Valid $lastName";
    }
    return '';
  }
/*
  static String validateLName(String value) {
    String patttern = r'(^[a-zA-Z]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length < 2) {
      return "Enter Valid Last Name";
    }
    else if (value.contains(' ')){
      return "Username cannot contains spaces";
    }
    else if (!regExp.hasMatch(value)) {
      return "Enter Valid Last Name";
    }
    return '';
  }*/

  static String validateUserName(String value) {
    //String patttern = r'(^[a-zA-Z 0-9]*$)';
    //  RegExp regExp = new RegExp(patttern);
    if (value.length <= 3) {
      return "Enter Valid Username";
    }
    else if (value.contains(' ')){
      return "Username cannot contains spaces";
    }
    /*else if (!regExp.hasMatch(value)) {
      return "Enter Valid Name";
    }*/
    return '';
  }
}
