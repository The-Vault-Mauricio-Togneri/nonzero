import 'package:flutter/material.dart';
import 'package:nonzero/services/routes.dart';

class OptionsDialog {
  static Future<bool?> show({
    required List<Option> options,
  }) {
    return showDialog(
      context: Routes.context(),
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final Option option in options)
                ListTile(
                  title: Text(option.text),
                  onTap: () {
                    Routes.pop();
                    option.callback();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class Option {
  final String text;
  final VoidCallback callback;

  const Option({
    required this.text,
    required this.callback,
  });
}
