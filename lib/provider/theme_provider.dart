import 'dart:developer';

import 'package:chat_app/models/local_storagr.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeMode themeMode;

  ThemeProvider(String theme) {
    if (theme == 'light') {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
  }

  void toggleTheme() async {
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
      await LocalStorgarTheme.saveTheme('dark');
      log("calling ho rhi hai kya????.");
    } else {
      themeMode = ThemeMode.light;
      await LocalStorgarTheme.saveTheme('light');
      log("calling ho rhi hai kya????.");
    }
    notifyListeners();
  }
}
