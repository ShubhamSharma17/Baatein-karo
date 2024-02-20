import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/provider/theme_provider.dart';
import 'package:chat_app/screen/auth/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider = Provider.of(context, listen: false);
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login Screen',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 21,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            padding: const EdgeInsets.all(0),
            icon: (themeProvider.themeMode == ThemeMode.light)
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.light),
          )
        ],
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Center(
          child: Column(
            children: [
              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Chat App",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w500,
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
              const SizedBox(height: 40),
              CupertinoButton(
                onPressed: () {
                  authProvider.login(emailController.text.trim(),
                      passwordController.text.trim(), context);
                },
                color: Colors.blue,
                child: const Text(
                  "Log In",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have a account?"),
            TextButton(
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context) {
                    return const SignUpPage();
                  },
                ));
              },
              child: const Text("Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
