import 'package:flutter/material.dart';
import 'package:nonzero/screens/main_screen.dart';
import 'package:nonzero/services/palette.dart';
import 'package:nonzero/services/routes.dart';

class NonZero extends StatelessWidget {
  const NonZero();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Non Zero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Palette.primary,
        backgroundColor: Palette.white,
        scaffoldBackgroundColor: Palette.white,
      ),
      navigatorKey: Routes.get.key,
      home: MainScreen(),
    );
  }
}
