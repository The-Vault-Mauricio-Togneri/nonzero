import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nonzero/app/app.dart';
import 'package:nonzero/app/initializer.dart';

Future main() async {
  await Initializer.set();
  runApp(const NonZero());
}
