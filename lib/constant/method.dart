import 'dart:developer';
import 'dart:io';

import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Future<UserModel> getUserfromId(String uid) async {
    UserModel? userModel;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("user").doc(uid).get();
    userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    return userModel;
  }
}
