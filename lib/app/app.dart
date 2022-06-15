import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nonzero/screens/connection_screen.dart';
import 'package:nonzero/services/localizations.dart';
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
      localizationsDelegates: const [
        CustomLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: Localized.locales,
      home: ConnectionScreen(),
    );
  }
}
