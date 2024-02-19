import 'dart:developer';
import 'dart:io';

class ConstantMethod {
  static bool valueCheckForSignUP(
      String name, email, password, cPassword, phoneNumber, File? imagepath) {
    if (name == "" ||
        email == "" ||
        password == "" ||
        cPassword == "" ||
        phoneNumber == "" ||
        imagepath == null) {
      log("Fill all the feilds carefully.....");
      return false;
    } else if (password != cPassword) {
      log("Password does not match!..");
      return false;
    } else if (phoneNumber.length != 10) {
      log("Enter correct phone number!");
      return false;
    } else {
      // call sign up method
      return true;
    }
  }
}
