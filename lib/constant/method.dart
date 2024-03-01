import 'dart:developer';
import 'dart:io';

import 'package:chat_app/helper/ui_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ConstantMethod {
  static bool valueCheckForSignUP(String name, email, password, cPassword,
      phoneNumber, File? imagepath, BuildContext context) {
    if (name == "" ||
        email == "" ||
        password == "" ||
        cPassword == "" ||
        phoneNumber == "" ||
        imagepath == null) {
      UiHelper.showalertbox(
          context, "Fill all the feilds carefully.....", "An error occured!");
      log("Fill all the feilds carefully.....");
      return false;
    } else if (password != cPassword) {
      UiHelper.showalertbox(
          context, "Password does not match!..", "An error occured!");
      log("Password does not match!..");
      return false;
    } else if (phoneNumber.length != 10) {
      UiHelper.showalertbox(
          context, "Enter correct phone number!", "An error occured!");
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
