// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:chat_app/helper/ui_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screen/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationProvider with ChangeNotifier {
  Future<UserCredential?> signUp(
      String email, String password, BuildContext context) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      log(error.code.toString());
    }
    notifyListeners();
    return userCredential;
  }

  void login(String email, String password, BuildContext context) async {
    UserCredential? userCredencial;
    UiHelper.showloadingBox(context, "Loading..");
    try {
      userCredencial = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) return;
      Navigator.pop(context);
      UiHelper.showalertbox(
          context, error.code.toString(), "An error occured!");
      log(error.code.toString());
    }
    if (userCredencial != null) {
      String uid = userCredencial.user!.uid;

      DocumentSnapshot snapshort =
          await FirebaseFirestore.instance.collection("user").doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(snapshort.data() as Map<String, dynamic>);
      User firebaseUser = FirebaseAuth.instance.currentUser!;
      log('user successfully login...');
      if (!context.mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) {
          return HomePage(
            userModel: userModel,
            firebaseUser: firebaseUser,
          );
        },
      ));
    }
    notifyListeners();
  }
}
