import 'package:flutter/material.dart';
import 'package:nonzero/services/routes.dart';

class ConfirmationDialog {
  static void show({
    required BuildContext context,
    required String message,
    required VoidCallback callback,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: Routes.pop,
              child: Text('Cancel'.toUpperCase()),
            ),
            TextButton(
              onPressed: () {
                Routes.pop();
                callback();
              },
              child: Text('Ok'.toUpperCase()),
            ),
          ],
        );
      },
    );
  }
}
