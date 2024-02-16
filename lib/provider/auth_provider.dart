import 'dart:developer';

import 'package:chat_app/screen/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationProvider with ChangeNotifier {
  Future<UserCredential?> signUp(String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      log(error.code.toString());
    }
    if (userCredential != null) {
      log('user created succefully......');
    }
    notifyListeners();
    return userCredential;
  }

  void login(String email, String password, BuildContext context) async {
    UserCredential? userCredencial;
    try {
      userCredencial = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      log(error.code.toString());
    }
    if (userCredencial != null) {
      log('user successfullt login...');
      if (!context.mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) {
          return const HomePage();
        },
      ));
    }
    notifyListeners();
  }
}
