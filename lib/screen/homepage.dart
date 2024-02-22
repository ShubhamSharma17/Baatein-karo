import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screen/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User firebaseUser;
  final UserModel userModel;

  const HomePage({
    super.key,
    required this.firebaseUser,
    required this.userModel,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text("Usermodel data ${widget.userModel.name}"),
              Text("firebase user data ${widget.firebaseUser.email}"),
            ],
          ),
        ),
      ),
    );
  }
}
