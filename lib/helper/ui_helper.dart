import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiHelper {
  static void showloadingBox(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 15),
              Text(content),
            ],
          ),
        );
      },
    );
  }

  static void showalertbox(BuildContext context, String content, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(content),
                const SizedBox(height: 15),
                CupertinoButton(
                    child: const Text("ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ));
      },
    );
  }
}
