import 'package:flutter/material.dart';

enum Priority {
  high,
  medium,
  low;

  Color get color {
    switch (this) {
      case Priority.high:
        return const Color(0xFFABCF81);
      case Priority.medium:
        return const Color(0xFFECC081);
      case Priority.low:
        return const Color(0xFFFA928D);
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
