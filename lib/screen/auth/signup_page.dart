import 'dart:developer';
import 'dart:io';

import 'package:chat_app/constant/method.dart';
import 'package:chat_app/helper/ui_helper.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/screen/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  late bool check;
  UserCredential? userCredential;

  File? imageFile;

  String? imageUrl;

  void showPhotoOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Choose one option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void selectImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      cropImage(pickedImage);
    }
  }

  void cropImage(XFile selecetImage) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: selecetImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 30,
    );

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
        log(imageFile!.path.toString());
      });
    }
  }

  void uploadImage() async {
    UploadTask task = FirebaseStorage.instance
        .ref("profilepictue")
        .child(userCredential!.user!.uid.toString())
        .putFile(imageFile!);
    TaskSnapshot snapshot = await task;

    imageUrl = await snapshot.ref.getDownloadURL();
    log("image uploading.....");
    uploadData();
  }

  void uploadData() {
    String uid = userCredential!.user!.uid;
    User firebaseUser = FirebaseAuth.instance.currentUser!;

    UserModel userModel = UserModel(
      uid: uid,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      profilePicture: imageUrl,
    );

    FirebaseFirestore.instance.collection("user").doc(uid).set(
          userModel.toMap(),
        );
    log("User data successfully uploaded..");
    if (!context.mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomePage(
        userModel: userModel,
        firebaseUser: firebaseUser,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sign Up Screen',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 21,
          ),
        ),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: Column(
              children: [
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    showPhotoOption();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        imageFile != null ? FileImage(imageFile!) : null,
                    child: imageFile == null
                        ? const Icon(Icons.person, size: 38)
                        : null,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outlined),
                    labelText: "Name",
                    hintText: "Enter Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail),
                    labelText: "Email Address",
                    hintText: "Enter Email Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: phoneController,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_android),
                    labelText: "Phone Number",
                    hintText: "Enter Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.remove_red_eye),
                    labelText: "Password",
                    hintText: "Enter Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: cPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.remove_red_eye),
                    labelText: "Confirm Password",
                    hintText: "Enter Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                CupertinoButton(
                  onPressed: () async {
                    check = ConstantMethod.valueCheckForSignUP(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        cPasswordController.text.trim(),
                        phoneController.text.trim(),
                        imageFile,
                        context);
                    if (check) {
                      UiHelper.showloadingBox(context, "Create account...");
                      log("sign up method calling.....");
                      userCredential = await authProvider.signUp(
                        emailController.text.trimLeft(),
                        passwordController.text.trim(),
                        context,
                      );
                      if (userCredential != null) {
                        uploadImage();
                      }
                    }
                  },
                  color: Colors.blue,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have a account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Log In"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
