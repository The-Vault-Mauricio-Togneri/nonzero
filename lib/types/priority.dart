import 'package:flutter/material.dart';

enum Priority {
  high,
  medium,
  low;

  Color get color {
    switch (this) {
      case Priority.high:
        return Colors.red.shade200;
      case Priority.medium:
        return Colors.yellow.shade200;
      case Priority.low:
        return Colors.green.shade200;
    }
  }

  static Priority parse(String name) {
    for (final value in Priority.values) {
      if (value.name == name) {
        return value;
      }
    }

    throw Error();
  }
}
