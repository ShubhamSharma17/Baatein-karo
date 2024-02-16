import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
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
                // const Text(
                //   "Welcome to",
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // const Text(
                //   "Chat App",
                //   style: TextStyle(
                //     fontSize: 34,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                const SizedBox(height: 30),
                const CircleAvatar(
                  radius: 50,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail),
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
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail),
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
                  onPressed: () {},
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
