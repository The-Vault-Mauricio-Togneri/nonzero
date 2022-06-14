import 'package:flutter/material.dart';

enum Priority {
  high,
  medium,
  low,
}

extension PriorityExtension on Priority {
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
}
