import 'package:flutter/material.dart';
import 'package:nonzero/services/localizations.dart';
import 'package:nonzero/services/navigation.dart';

class ConfirmationDialog {
  static Future<bool?> show({
    required String message,
    VoidCallback? callback,
  }) {
    return showDialog(
      context: Navigation.context(),
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: Navigation.pop,
              child: Text(Localized.get.buttonCancel.toUpperCase()),
            ),
            TextButton(
              onPressed: () {
                Navigation.pop(true);
                callback?.call();
              },
              child: Text(Localized.get.buttonOk.toUpperCase()),
            ),
          ],
        );
      },
    );
  }
}
