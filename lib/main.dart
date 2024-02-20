import 'package:chat_app/constant/theme.dart';
import 'package:chat_app/models/local_storagr.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/provider/theme_provider.dart';
import 'package:chat_app/screen/auth/login_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String theme = await LocalStorgarTheme.getTheme() ?? 'light';
  await Firebase.initializeApp();
  runApp(MyApp(
    currentTheme: theme,
  ));
}

class MyApp extends StatelessWidget {
  final String currentTheme;
  const MyApp({
    required this.currentTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(currentTheme),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Baatein Karo',
            themeMode: themeProvider.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
